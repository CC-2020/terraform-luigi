# Cloud Computing - UHU | Tarea sobre Terraform


- Crear una instancia con ubuntu-1910 - n1-standard-1 - us-central1-a.
- Instalar apache, php, mysql
- Set standard network
- Firewall configuration (icmp, tcp, 80, 22)


## Instalar Terraform
En Cloud Shell de GCP __Terraform__ ya está instalado, si tuviéramos que instalarlo, las instrucciones de instalación son:

```bash
$ sudo apt update
$ sudo apt-get install wget unzip
$ wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
$ sudo unzip ./terraform_0.12.24_linux_amd64.zip -d /usr/local/bin/
```
Para comprobar la instalación:
```bash
$ terraform -v
```
así podemos ver la versión de terraform instalada.

## Fichero de configuración .tf

Ahora creemos el archivo de configuración para la infraestructura que queremos construir.

```
//create instance
resource "google_compute_instance" "createbyterraform" {
  name         = "terraform"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1910"
    }
  }
  //install apache+mysql+php
  metadata_startup_script = "sudo apt update && sudo apt install apache2 mysql-server php php-mysql -y"
  network_interface {
    network = google_compute_network.default.self_link
    access_config {

    }
  }
}
//firewall https://www.terraform.io/docs/providers/google/r/compute_firewall.html
resource "google_compute_firewall" "icmp-ssh-http" {
  name    = "myfirewall"
  network = google_compute_network.default.self_link
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
}
//network
resource "google_compute_network" "default" {
  name = "mynetwork"
}
```

## terraform init
Antes de lanzar Terraform es necesario inicializarlo:
```
$ terraform init
Initializing the backend...
Initializing provider plugins...
The following providers do not have any version constraints in configuration,
so the latest version was installed.
To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.
* provider.google: version = "~> 3.16"
Terraform has been successfully initialized!
You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
``` 

## terrafrom apply

Lanzamos ahora nuestra infraestructura.

```
terraform apply
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
Terraform will perform the following actions:
  # google_compute_firewall.icmp-ssh-http will be created
  + resource "google_compute_firewall" "icmp-ssh-http" {
      + creation_timestamp = (known after apply)
      + destination_ranges = (known after apply)
      + direction          = (known after apply)
      + id                 = (known after apply)
      + name               = "myfirewall"
      + network            = (known after apply)
      + priority           = 1000
      + project            = (known after apply)
      + self_link          = (known after apply)
      + source_ranges      = (known after apply)
      + allow {
          + ports    = [
              + "80",
              + "22",
            ]
          + protocol = "tcp"
        }
      + allow {
          + ports    = []
          + protocol = "icmp"
        }
    }
  # google_compute_instance.createbyterraform will be created
  + resource "google_compute_instance" "createbyterraform" {
      + can_ip_forward          = false
      + cpu_platform            = (known after apply)
      + current_status          = (known after apply)
      + deletion_protection     = false
      + guest_accelerator       = (known after apply)
      + id                      = (known after apply)
      + instance_id             = (known after apply)
      + label_fingerprint       = (known after apply)
      + machine_type            = "n1-standard-1"
      + metadata_fingerprint    = (known after apply)
      + metadata_startup_script = "sudo apt update && sudo apt install apache2 mysql-server php php-mysql -y"
      + min_cpu_platform        = (known after apply)
      + name                    = "terraform"
      + project                 = (known after apply)
      + self_link               = (known after apply)
      + tags_fingerprint        = (known after apply)
      + zone                    = "us-central1-a"
      + boot_disk {
          + auto_delete                = true
          + device_name                = (known after apply)
          + disk_encryption_key_sha256 = (known after apply)
          + kms_key_self_link          = (known after apply)
          + mode                       = "READ_WRITE"
          + source                     = (known after apply)
          + initialize_params {
              + image  = "ubuntu-os-cloud/ubuntu-1910"
              + labels = (known after apply)
              + size   = (known after apply)
              + type   = (known after apply)
            }
        }

      + network_interface {
          + name               = (known after apply)
          + network            = (known after apply)
          + network_ip         = (known after apply)
          + subnetwork         = (known after apply)
          + subnetwork_project = (known after apply)
          + access_config {
              + nat_ip       = (known after apply)
              + network_tier = (known after apply)
            }
        }
      + scheduling {
          + automatic_restart   = (known after apply)
          + on_host_maintenance = (known after apply)
          + preemptible         = (known after apply)
          + node_affinities {
              + key      = (known after apply)
              + operator = (known after apply)
              + values   = (known after apply)
            }
        }
    }
  # google_compute_network.default will be created
  + resource "google_compute_network" "default" {
      + auto_create_subnetworks         = true
      + delete_default_routes_on_create = false
      + gateway_ipv4                    = (known after apply)
      + id                              = (known after apply)
      + ipv4_range                      = (known after apply)
      + name                            = "mynetwork"
      + project                         = (known after apply)
      + routing_mode                    = (known after apply)
      + self_link                       = (known after apply)
    }
Plan: 3 to add, 0 to change, 0 to destroy.
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.
  Enter a value: yes
google_compute_network.default: Creating...
google_compute_network.default: Still creating... [10s elapsed]
google_compute_network.default: Still creating... [20s elapsed]
google_compute_network.default: Still creating... [30s elapsed]
google_compute_network.default: Still creating... [40s elapsed]
google_compute_network.default: Creation complete after 42s [id=projects/cloud-computing-271319/global/networks/mynetwork]
google_compute_firewall.icmp-ssh-http: Creating...
google_compute_instance.createbyterraform: Creating...
google_compute_firewall.icmp-ssh-http: Still creating... [10s elapsed]
google_compute_instance.createbyterraform: Still creating... [10s elapsed]
google_compute_firewall.icmp-ssh-http: Creation complete after 11s [id=projects/cloud-computing-271319/global/firewalls/myfirewall]
google_compute_instance.createbyterraform: Creation complete after 14s [id=projects/cloud-computing-271319/zones/us-central1-a/instances/terraform]
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```


## Test

Para probar lo que hemos hecho, simplemente ir sobre GCP, en "Compute Engine", "Instance VM" y ver la instancia de "terraform", copiar y pegar la dirección IP externa en el browser, veremos la página de bienvenida de Apache.