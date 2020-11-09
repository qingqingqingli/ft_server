[![Logo](https://github.com/qingqingqingli/readme_images/blob/master/codam_logo_1.png)](https://github.com/qingqingqingli/ft_server)

# ft_server
***This is a System Administration project. It demonstrates the importance of using scripts to automate tasks. This project uses Docker technology to set up a web server, which will run multiple services (```Wordpress```, ```PhpMyAdmin```, ```MySQL```).***

## Technical considerations

- ```Docker-compose``` is not allowed
- Container OS must be ```debian buster```
- The server needs to use the ```SSL``` protocol
- The server ```redirects``` to the correct website based on the url

## How to test
> Run the following commands

```shell
$ git clone https://github.com/qingqingqingli/ft_server
$ cd ft_server
$ docker build -t ft_server .
$ docker run -it -p 80:80 -p 443:443 ft_server
```

> Wordpress can be accessed at

```shell
https://localhost
```

> Phpmyadmin can be accessed at

```shell
https://localhost/phpmyadmin
username = qli
password = server
```

## Examples

- The process to build the docker image can take a few minutes

[![ft_server_1](https://github.com/qingqingqingli/readme_images/blob/master/ft_server_1.png)](https://github.com/qingqingqingli/ft_server)

- Run docker image

[![ft_server_2](https://github.com/qingqingqingli/readme_images/blob/master/ft_server_2.png)](https://github.com/qingqingqingli/ft_server)

- Wordpress service page

[![ft_server_wordpress](https://github.com/qingqingqingli/readme_images/blob/master/ft_server_wordpress.png)](https://github.com/qingqingqingli/ft_server)

- PhpMyAdmin service page

[![ft_server_pma_0](https://github.com/qingqingqingli/readme_images/blob/master/ft_server_pma_0.png)](https://github.com/qingqingqingli/ft_server)

- MySQL Wordpress database

[![ft_server_pma_2](https://github.com/qingqingqingli/readme_images/blob/master/ft_server_pma_2.png)](https://github.com/qingqingqingli/ft_server)
