<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/twplatformlabs/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/twplatformlabs/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-aws-platform-vpc</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/twplatformlabs/psk-aws-platform-vpc"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

While the PSK lab only makes use of two vpcs, a typical multi-region Engineering Platform would have many more.  

The orchestration follows the control plane cluster release path to production.  

```mermaid
---
title: Typical Starting Platform VPC
---
flowchart LR

    GITPUSH --> DEV
    GITMERGE --> QA
    GITTAG --> PREVIEW --> NONPROD --> PROD
    GITTAG --> MAPI

    DEV["Sandbox
        (Platform Eng Only)"]
    QA["QA
        (Platform Eng Only)"]
    PREVIEW["Preview
            (Developer Facing)"]
    MAPI["MAPI
            (Managment)"]
    NONPROD["Non-production
            (Developer Facing)"]
    PROD["Production
            (Developer Facing)"]

    GITPUSH@{ shape: brace-r, label: "$ git push _branch_" }
    GITMERGE@{ shape: brace-r, label: "$ git merge _main_" }
    GITTAG@{ shape: brace-r, label: "$ git tag _1.3.3_" }
```

Also, note that having multiple cluster in multiple regions as part of the same role requires a more complex network configuration. For cost purposes, our live lab environment does not make use of either multi-region clusters nor networks. See the psk-aws-platform-wan repo and inline comments in this repo for examples of such a configuration.  

## psk lab reservations and release pipeline
| vpc                     | region          | az                | az                | az                | total IPs |
|-------------------------|:---------------:|:-----------------:|:-----------------:|:-----------------:|:---------:|
|                         |                 |                   |                   |                   |           |
| dps-2                   | us-east-1       | us-east-1a        |   us-east-1b      |  us-east-1c       |           |
| sbx-i01-aws-us-east-1   | 10.90.0.0/16    |                   |                   |                   |           |
| private  (nodes)        |                 | 10.80.0.0/18      | 10.80.64.0/18     | 10.80.128.0/18    | 49,146    |
| intra<sup>*</sup>       |                 | 10.80.192.0/20    | 10.80.208.0/20    | 10.80.224.0/20    | 12,282    |
| database                |                 | 10.80.240.0/23    | 10.80.242.0/23    | 10.80.244.0/23    | 1,530     |
| public   (ingress)      |                 | 10.80.246.0/23    | 10.80.248.0/23    | 10.80.250.0/23    | 1,530     |
|                         |                 |                   |                   | unallocated addr  | 1047      |
|                         |                 |                   |                   |                   |           |
| dps-1                   | us-east-2       | us-east-2a        |   us-east-2b      |  us-east-2c       |           |
| prod-i01-aws-us-east-1  | 10.90.0.0/16    |                   |                   |                   |           |
| private (nodes)         |                 | 10.90.0.0/18      | 10.90.64.0/18     | 10.90.128.0/18    | 49,146    |
| intra<sup>*</sup>       |                 | 10.90.192.0/20    | 10.90.208.0/20    | 10.90.224.0/20    | 12,282    |
| database                |                 | 10.90.240.0/23    | 10.90.242.0/23    | 10.90.244.0/23    | 1,530     |
| public   (ingress)      |                 | 10.90.246.0/23    | 10.90.248.0/23    | 10.90.250.0/23    | 1,530     |
|                         |                 |                   |                   | unallocated addr  | 1047      |

<sup>*</sup>private subnet with no internet routing (in the sense of RFC1918 Category 1), commonly used for Lambda functions ENI allocations.
```mermaid
---
title: Platform VPC default configuration
---
flowchart LR

    PUBa --- PUBb --- PUBc --> IGW
    PRIa --- PRIb --- PRIc --> NATGW --> IGW --> CLOUDOUT

    LB --- FW --- | future istio managed | CLOUD
    CLOUD@{ shape: cloud, label: "Ingress"}
    FW[Firewall]
    style LB color:#fff,stroke:#388E3C,stroke-width:2px,stroke-dasharray:5 5
    style FW color:#fff,stroke:#388E3C,stroke-width:2px,stroke-dasharray:5 5
    style CLOUD color:#fff,stroke:#388E3C,stroke-dasharray:5 5
    linkStyle 8 stroke:#4CAF50,stroke-width:3px,stroke-dasharray:5 5
    linkStyle 9 stroke:#4CAF50,stroke-width:3px,stroke-dasharray:5 5

    IGW[Internet Gateway]
    CLOUDOUT@{ shape: cloud, label: "388E3Cgress"}
    
    CON@{ shape: braces, label: "map_public_ip_on_launch=false
         enable_dns_hostnames=true
         enable_dns_support=true
         "}

    CIDR23@{ shape: brace-r, label: "1,528 addresses"}
    CIDR20@{ shape: brace-r, label: "12,280 addresses"}
    CIDR18@{ shape: brace-r, label: "49,144 addresses"}
    CIDR23 --- PUBa & DBa
    CIDR20 --- INTRa
    CIDR18 ---PRIa

    subgraph VPC /16
        subgraph Zone c
            subgraph Database /23
                DBc["Tier = database"]
            end
            subgraph Intra /20
                INTRc["Tier = intra"]
            end
            subgraph Public /23
                PUBc["Tier = public
                    kubernetes.io/role/elb = 1"]
                NATGW[NAT Gateway]
                LB[Load Balancer]
            end
            subgraph Private Subnet /18
                PRIc["Tier = node
                    karpenter.sh/discovery"]
            end
        end
        subgraph Zone b
            subgraph Database /23
                DBb["Tier = database"]
            end
            subgraph Intra /20
                INTRb["Tier = intra"]
            end
            subgraph Public /23
                PUBb["Tier = public
                    kubernetes.io/role/elb = 1"]
            end
            subgraph Private Subnet /18
                PRIb["Tier = node
                    karpenter.sh/discovery"]
            end
        end
        subgraph Zone a
            subgraph Database /23
                DBa["Tier = database"]
            end
            subgraph Intra /20
                INTRa["Tier = intra"]
            end
            subgraph Public /23
                PUBa["Tier = public
                    kubernetes.io/role/elb = 1"]
            end
            subgraph Private Subnet /18
                PRIa["Tier = node
                    karpenter.sh/discovery"]
            end
        end
    end
```
```mermaid
---
title: simplified lab example
---
flowchart LR

    GITPUSH --> DEV
    GITTAG --> PROD

    DEV[sbx-i01-aws-us-east-1-vpc]
    PROD[prod-i01-aws-us-east-1-vpc]

    GITPUSH@{ shape: brace-r, label: "$ git push" }
    GITTAG@{ shape: brace-r, label: "$ git tag _1.3.3_" }
```

Maintainer notes found [here](doc/maintainer_notes.md).
