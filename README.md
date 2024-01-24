<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-aws-platform-vpc</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/psk-aws-platform-vpc"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

While the PSK lab only makes use of two vpcs, a typical multi-region Engineering Platform would have many more.

Also, note that having multiple cluster in multiple regions as part of the same role requires a more complex network configuration. For cost purposes, our live lab environment does not make use of either multi-region clusters nor networks. See the ps-aws-platform-wan repo and inline comments in this repo for examples of such a configuration.  

## reservations

| vpc                     | region          | az                | az                | az                |
|-------------------------|:---------------:|:-----------------:|:-----------------:|:-----------------:|
|                         |                 |                   |                   |                   |
| dps-2                   | us-east-1       | us-east-1a        |   us-east-1b      |  us-east-1c       |
| sbx-i01-aws-us-east-1   | 10.80.0.0/16    |                   |                   |                   |
| private  (nodes)        |                 | 10.80.0.0/18      | 10.80.64.0/18     | 10.80.128.0/18    |
| public   (ingress)      |                 | 10.80.240.0/26    | 10.80.240.64/26   | 10.80.240.128/26  |
| database                |                 | 10.80.192.0/20    | 10.80.208.0/20    | 10.80.224.0/20    |
|                         |                 |                   |                   |                   |
| dps-1                   | us-east-2       | us-east-2a        |   us-east-2b      |  us-east-2c       |
| prod-i01-aws-us-east-1  | 10.90.0.0/16    |                   |                   |                   |
| private                 |                 | 10.90.0.0/18      | 10.90.64.0/18     | 10.90.128.0/18    |
| public  				        |                 | 10.90.240.0/26    | 10.90.240.64/26   | 10.90.240.128/26  |
| database                |                 | 10.90.192.0/20    | 10.90.208.0/20    | 10.90.224.0/20    |

Maintainer notes found [here](doc/maintainer_notes.md).
