<h2>Deploying a simple wordpress site in AWS using Terraform</h2>
<hr>
<img src ="https://i2.wp.com/www.linuxguy.io/wp-content/uploads/2021/10/simple-wp-blog-terraform-aws.png?w=921&ssl=1"/>

<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Name</th>
<th>Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>&lt;a name=“requirement_aws”&gt;&lt;/a&gt; <a href="#requirement_aws">aws</a></td>
<td>~&gt; 3.0</td>
</tr>
</tbody>
</table>
<h2 class="code-line" data-line-start=4 data-line-end=5 ><a id="Providers_4"></a>Providers</h2>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Name</th>
<th>Version</th>
</tr>
</thead>
<tbody>
<tr>
<td>&lt;a name=“provider_aws”&gt;&lt;/a&gt; <a href="#provider_aws">aws</a></td>
<td>3.63.0</td>
</tr>
</tbody>
</table>
<h2 class="code-line" data-line-start=10 data-line-end=11 ><a id="Modules_10"></a>Modules</h2>
<p class="has-line-data" data-line-start="12" data-line-end="13">No modules.</p>
<h2 class="code-line" data-line-start=14 data-line-end=15 ><a id="Resources_14"></a>Resources</h2>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Name</th>
<th>Type</th>
</tr>
</thead>
<tbody>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance">aws_db_instance.blog-database</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group">aws_db_subnet_group.mydb-subnet-group</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance">aws_instance.webserver-instance</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway">aws_internet_gateway.my-ig</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route">aws_route.public-subnet-route</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group">aws_security_group.database-sg</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group">aws_security_group.webserver-sg</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet">aws_subnet.private-subnet</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet">aws_subnet.private-subnet-2</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet">aws_subnet.public-subnet</a></td>
<td>resource</td>
</tr>
<tr>
<td><a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc">aws_vpc.vpc-wp-blog</a></td>
<td>resource</td>
</tr>
</tbody>
</table>
<h2 class="code-line" data-line-start=30 data-line-end=31 ><a id="Inputs_30"></a>Inputs</h2>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Name</th>
<th>Description</th>
<th>Type</th>
<th>Default</th>
<th style="text-align:center">Required</th>
</tr>
</thead>
<tbody>
<tr>
<td>&lt;a name=“input_app_region”&gt;&lt;/a&gt; <a href="#input_app_region">app_region</a></td>
<td>this is the region where our blog will be deployed</td>
<td><code>string</code></td>
<td><code>&quot;ap-southeast-2&quot;</code></td>
<td style="text-align:center">no</td>
</tr>
<tr>
<td>&lt;a name=“input_az”&gt;&lt;/a&gt; <a href="#input_az">az</a></td>
<td>this is the availability zone where the subnet will be created</td>
<td><code>string</code></td>
<td><code>&quot;ap-southeast-2b&quot;</code></td>
<td style="text-align:center">no</td>
</tr>
<tr>
<td>&lt;a name=“input_db_password”&gt;&lt;/a&gt; <a href="#input_db_password">db_password</a></td>
<td>database password</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align:center">yes</td>
</tr>
<tr>
<td>&lt;a name=“input_db_username”&gt;&lt;/a&gt; <a href="#input_db_username">db_username</a></td>
<td>database username</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align:center">yes</td>
</tr>
<tr>
<td>&lt;a name=“input_image_id”&gt;&lt;/a&gt; <a href="#input_image_id">image_id</a></td>
<td>image id for the webserver instance</td>
<td><code>string</code></td>
<td>n/a</td>
<td style="text-align:center">yes</td>
</tr>
<tr>
<td>&lt;a name=“input_vpc_cidr_block”&gt;&lt;/a&gt; <a href="#input_vpc_cidr_block">vpc_cidr_block</a></td>
<td>this is the cidr block for your VPC</td>
<td><code>string</code></td>
<td><code>&quot;10.0.0.0/16&quot;</code></td>
<td style="text-align:center">no</td>
</tr>
<tr>
<td>&lt;a name=“input_webserver_instance_type”&gt;&lt;/a&gt; <a href="#input_webserver_instance_type">webserver_instance_type</a></td>
<td>instance type for webserver</td>
<td><code>string</code></td>
<td><code>&quot;t2.micro&quot;</code></td>
<td style="text-align:center">no</td>
</tr>
</tbody>
</table>
<h2 class="code-line" data-line-start=42 data-line-end=43 ><a id="Outputs_42"></a>Outputs</h2>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Name</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>&lt;a name=“output_database-endpoint”&gt;&lt;/a&gt; <a href="#output_database-endpoint">database-endpoint</a></td>
<td>Endpoint for the database serever</td>
</tr>
<tr>
<td>&lt;a name=“output_ip-address”&gt;&lt;/a&gt; <a href="#output_ip-address">ip-address</a></td>
<td>IP address of webserver</td>
</tr>
</tbody>
</table>
