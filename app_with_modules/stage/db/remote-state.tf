data "terraform_remote_state" "network" {
    backend            = "s3"
    config = {
        bucket         = "visij-tf-state"
        key            = "use-enviroment/stage/network/terraform.tfstate"
        region         = "us-east-1"
    }
} 

