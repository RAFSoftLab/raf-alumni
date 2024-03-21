from django.core.management.base import BaseCommand
from time import sleep
from django.conf import settings

import base64
import pika
import json
import os

class Command(BaseCommand):
    help = 'Starts a RabbitMQ consumer that listens for messages continuously with reconnection logic.'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('Starting RabbitMQ consumer with reconnection logic...'))
        self.run_consumer()

    def run_consumer(self):
        while True:
            try:
                queue_name = 'raf_service_queue'
                exchange_name = 'raf_service_exchange'
                
                connection = pika.BlockingConnection(pika.ConnectionParameters(host=os.environ['RABBITMQ_HOST'], heartbeat=600))
                channel = connection.channel()
                
                self.stdout.write(self.style.SUCCESS('Connected to RabbitMQ. Waiting for messages...'))

                channel.queue_declare(queue=queue_name, durable=True)
                channel.exchange_declare(exchange=exchange_name, exchange_type='direct')

                def callback(ch, method, properties, body):
                    data = json.loads(body.decode('utf-8'))
                    self.stdout.write(self.style.SUCCESS(f'Received data in RabbitMQ: {data}. Processing message...'))
                    
                    # TODO: Process the message
                    
                    self.stdout.write(self.style.SUCCESS(f'Successfully processed message'))

                channel.queue_bind(
                    exchange=exchange_name,
                    queue=queue_name,
                    routing_key='raf_service_key'
                )
                channel.basic_consume(
                    queue=queue_name,
                    on_message_callback=callback,
                    auto_ack=True
                )

                try:
                    channel.start_consuming()
                except KeyboardInterrupt:
                    channel.stop_consuming()
                    connection.close()
                    break  # Exit the loop to stop the command
                except Exception as e:
                    self.stdout.write(self.style.ERROR(f'Error consuming messages: {e}'))
                    # Attempt to gracefully close the connection before retrying
                    try:
                        if not connection.is_closed:
                            connection.close()
                    except Exception as close_e:
                        self.stdout.write(self.style.ERROR(f'Error closing the connection: {close_e}'))
                    self.stdout.write(self.style.WARNING('Connection lost. Reconnecting in 5 seconds...'))
                    sleep(5)  # Wait before retrying the connection

            except pika.exceptions.AMQPConnectionError as conn_error:
                self.stdout.write(self.style.ERROR(f'AMQP Connection Error: {conn_error}. Retrying in 10 seconds...'))
                sleep(10)  # Wait a bit before retrying the connection
