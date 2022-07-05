# terraformTechnical

It's worth mentioning that I have not used Terraform before this assessment, but I am eager to learn how it is utilized. I understood the requirements and how I would approach them 'manually' via the AWS console, but scripting this architecture out in Terraform is new territory for me.

######################################################################################

I don't typically create diagrams from scratch, so I found an online tool here to map out my thought process on how to create this system
https://online.visual-paradigm.com

This video was extremely helpful in explaining the scruture of a terraform project - I followed it exactly, then assessed where changes to this tutorial project would be needed in order to build out the proof of concept requested. This gave me a skeleton to work on the rest of the requirements from.
Getting Started with EKS and Terraform
https://www.youtube.com/watch?v=Qy2A_yJH5-o

As the above video introduced me to the AWS modules, I began using more of this documentation from the modules github to fill out the project. I still followed through the video for syntax and structure guidance, but for the options specific to this project many of the answers I needed were in this repository.
https://github.com/terraform-aws-modules

After completing this video, I was able to sucessfully run 'terraform init' and the code seemed to be functional! I had an EKS auto scaling with a load balancer, but I did not yet have an S3 bucket nor the subnets defined via availability zone.

I found this article detailing how to map a subnet to an avaibility zone and incorporated this code in a new vpc.tf file
https://medium.com/@maneetkum/create-subnet-per-availability-zone-in-aws-through-terraform-ea81d1ec1883

I then added the S3 bucket with images and logs folders and their lifecycle policies following this article:
https://letslearndevops.com/2018/09/19/terraform-and-s3-lifecycle-rules/

I used this to define the Amazon linux most recent AMI as a variable to be used in each instance
https://www.hashicorp.com/blog/hashicorp-terraform-supports-amazon-linux-2

######################################################################################

I believe what I've put together is close, but am happy to take any feedback on parts I may have made mistakes on. This was my first time using terraform to script a project and it was quite an experience! I look forward to sharpening my skills with this tool and learning better ways to manage network architecture - hopefully as a part of your team!