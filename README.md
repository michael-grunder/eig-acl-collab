### EIG PhpRedis ACL colab


```
docker build . && docker run -it <image>
docker exec -it <container> bash

# Run the test program
$ php /root/test.php

# Try to catch an error via valgrind
$ ZEND_DONT_UNLOAD_MODULES=1 USE_ZEND_ALLOC=0 valgrind --suppressions=/root/vg.supp php /root/test.php -n 100
```
