[![Logo](https://github.com/qingqingqingli/readme_images/blob/master/codam_logo_1.png)](https://github.com/qingqingqingli/ft_server)

# ft_server
***This is a System Administration project. It demonstrates the importance of using scripts to automate tasks. This project uses Docker technology to set up a web server, which will run multiple services (```Wordpress```, ```PhpMyAdmin```, ```MySQL```).***

## Technical considerations

- Docker-compose is not allowed
- Container OS must be debian buster
- The server needs to use the SSL protocol
- The server redirects to the correct website based on the url

## How to test
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

## Examples

- The installation process can take a few minutes
![ft_server_example_1](https://github.com/qingqingqingli/readme_images/blob/master/ft_server_1.png)
