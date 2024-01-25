# Alumni Network

Alumni Network is a digital platform designed to connect alumni, facilitating networking, communication, and professional development. It features a user-friendly interface for alumni to update personal, contact, and employment information, engage in group discussions, access job postings, and participate in events. The system also includes administrative tools for faculty officers to manage content and communicate with alumni, alongside robust security, data analytics, and compatibility with various devices. This platform serves as a dynamic and interactive hub for alumni engagement and institutional support.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

List things you need to install the software and how to install them. For example:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Installation

 
#### Setting up the Backend

1. Clone the repository:

   ```bash
   git clone https://github.com/RAFSoftLab/alumni-network.git
   cd alumni-network
   ```

2. Navigate to the Django project directory:

    ```bash
    cd be
    ```

3. Use Docker Compose to build and run the backend service:

     ```bash
     docker-compose up --build
     ```

This will set up all necessary services defined in your docker-compose.yml file, such as the Django server.

### Post-installation Setup for Backend

After starting your Docker containers with `docker-compose up`, you will need to perform database migrations and create a superuser for Django.

1. **Enter the backend container**:

   First, find the container ID of your backend service using:

   ```bash
   docker ps
   ```

Look for the name of your Django backend container and note the container ID. Then, execute the following command to enter the container:

  ```bash
  docker exec -it [container-id] bash
  ```

Replace [container-id] with the actual ID of your container.


Run migrations:
Inside the container, navigate to the directory where your Django project is located (if not already there) and execute the database migrations:

```bash
python manage.py migrate
```

Ceate a superuser:

Still inside the container, create a Django superuser by running:
```bash
python manage.py createsuperuser
```

Follow the prompts to set up a username, email, and password for the superuser.

#### Setting up the Flutter Application

1. Navigate to the Flutter project directory:

    ```bash
    cd fe
    ```
    
2. Get all the dependencies:

    ```bash
    flutter pub get
    ```

3. Run the Flutter application:

    ```bash
    flutter run
    ```

Make sure an emulator is running or a device is connected to your machine.

### Accessing the Django Admin Panel

Once you have set up your superuser, you can access the Django admin panel to manage your application. Follow these steps to access the admin panel:

1. **Ensure your backend server is running**:

   Make sure your Django application is running inside the Docker container. If you've followed the previous steps, your server should be running on `localhost:8080`.

2. **Open a web browser**:

   Launch your preferred web browser.

3. **Navigate to the admin panel**:

   In the address bar of your browser, type the following URL and press Enter: http://localhost:8080/admin/

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/RAFSoftLab/alumni-network/blob/main/LICENSE) file for details.
