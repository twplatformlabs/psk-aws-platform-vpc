title "Platform VPCs"

require 'json'

tfvars = JSON.parse(File.read('./' + ENV['WORKSPACE'] + '.tfvars.json'))
client = Aws::EC2::Client.new(region: tfvars['aws_region'])

vpc = client.describe_vpcs({
                             filters: [
                               { name: "tag:Name", values: ["#{tfvars['instance_name']}-vpc"] }
                             ]
                           })

vpc_id = vpc.vpcs[0].vpc_id

control "platform-vpc-exists" do
  title "Check that platform VPC exists in region"

  describe aws_vpc(vpc_id) do
    it { should exist }
    its ('cidr_block') { should eq tfvars['vpc_cidr'] }
  end
end