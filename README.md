<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-aws-platform-vpc</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/psk-aws-platform-vpc"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

While the PSK lab only makes use of two vpc, a typical multi-region Engineering Platform would have many more. At which point the need arises to generate a deployment pipeline in an automated manner rather than manually maintain. This pipeline introduces the tool [circlecigen](https://github.com/ThoughtWorks-DPS/circlecigen) which demonstrates a python approach to managing what will increasing become a dynamic range of engineering platform components within circleci and terraform.  

## reservations


| vpc                     | region          | az                | az                | az                |
|-------------------------|:---------------:|:-----------------:|:-----------------:|:-----------------:|
|                         |                 |                   |                   |                   |
| dps-2                   | us-east-1       | us-east-1a        |   us-east-1b      |  us-east-1c       |
| sbx-i01-aws-us-east-1   | 10.80.0.0/16    |                   |                   |                   |
| private                 |                 | 10.80.0.0/18      | 10.80.64.0/18     | 10.80.128.0/18    |
| public                  |                 | 10.80.240.0/26    | 10.80.240.64/26   | 10.80.240.128/26  |
| database                |                 | 10.80.192.0/20    | 10.80.208.0/20    | 10.80.224.0/20    |
|                         |                 |                   |                   |                   |
| dps-1                   | us-east-2       | us-east-2a        |   us-east-2b      |  us-east-2c       |
| prod-i01-aws-us-east-1  | 10.90.0.0/16    |                   |                   |                   |
| private                 |                 | 10.90.0.0/18      | 10.90.64.0/18     | 10.90.128.0/18    |
| public  				  |                 | 10.90.240.0/26    | 10.90.240.64/26   | 10.90.240.128/26  |
| database                |                 | 10.90.192.0/20    | 10.90.208.0/20    | 10.90.224.0/20    |
