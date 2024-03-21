from rest_framework.response import Response
from django.core.cache import cache
import json

def custom_cache(timeout, key):
	def decorator(function):
		def wrap(request, *args, **kwargs):
			data = cache.get(key)
			if not data:
				result = function(request, *args, **kwargs)	
				cache.set(key, json.dumps(result.data), timeout)
				return result

			return Response(json.loads(data))

		wrap.__doc__ = function.__doc__
		wrap.__name__ = function.__name__
		return wrap
		
	return decorator