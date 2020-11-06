[![Logo](https://github.com/qingqingqingli/readme_images/blob/master/codam_logo_1.png)](https://github.com/qingqingqingli/ft_server)

## ft_server
***This is a System Administration project. The aim is to discover Docker and set up a web server, which will run multiple services (```Wordpress```, ```PhpMyAdmin```, ```MySQL```).***

### How to test
> Run the following commands

```shell
$ git clone https://github.com/qingqingqingli/ft_server ft_server
$ cd ft_server
$ docker build -t ft_server .
$ docker run -it -p 80:80 -p 443:443 ft_server
```

> Wordpress can be reached with

```shell
'https://localhost'
```

> Phpmyadmin can be reached with

```shell
'https://localhost/phpmyadmin'
username = qli
password = server
```

### Examples
