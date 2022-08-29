<!-- Improved compatibility of back to top link: See: https://github.com/natalicot/keda-demo-project/pull/73 -->
<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/natalicot/keda-demo-project">
    <img src="https://media.giphy.com/media/W0cnsqYq8vZmRr4JZS/giphy.gif" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">RMQ-AWS-K8S-KEDA-DEMO</h3>

  <p align="center">
    A demo project for working with keda scaler!
    <br />
    <a href="https://github.com/natalicot/keda-demo-project"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/natalicot/keda-demo-project">View Demo</a>
    ·
    <a href="https://github.com/natalicot/keda-demo-project/issues">Report Bug</a>
    ·
    <a href="https://github.com/natalicot/keda-demo-project/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->

## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

KEDA is a Kubernetes-based Event Driven Autoscaler. With KEDA, you can drive the scaling of any container in Kubernetes
based on the number of events needing to be processed.

This Demo Project lets you test KEDA for yourself.

Deploying a Local k8s Cluster using kind, Deploying a RMQ using Docker and Terraform on AWS EC2, Deploying 2 Golang
applications to your cluster, Using Keda to scale your application based on RMQ queues.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

All technologies used in this Project

* [![Kind][Kind.png]][Kind-URL]
* [![RMQ][RMQ.png]][RMQ-URL]
* [![terraform][terraform.png]][terraform-URL]
* [![Golang][Golang.png]][Golang-URL]
* [![Docker][Docker.png]][Docker-URL]
* [![Keda][Keda.png]][Keda-URL]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

* Kind create cluster
  ```sh
  kind create cluster --config=kind/cluster.yml
  ```

* Terraform apply
  ```sh 
  cd terraform 
  terraform apply
  ```

* Get RMQ IP and visit the RMQ console. psw and username: guest
  ```sh 
  terraform output public_dns
  ```

* Get RMQ connection string base64 encoded
  ```sh 
  echo -n "<public_dns>" | base64 
  echo -n 'amqp://guest:guest@<public_dns>:5672/' | base64
  ```

* Apply RMQ secrets
  ```sh 
  kubectl apply -f applications/rmq_secret.yml
  ```

* Install Publisher
  ```sh 
  kubectl apply -f applications/publisher/deployment.yml
  ```

* Port forward Publisher Service
  ```sh 
  kubectl port-forward svc/rabbitmq-publisher 8080:80
  ```

* Send Q
  ```sh 
  curl -X POST http://localhost:8080/publish/hello
  ```

* Install Consumer
  ```sh 
  kubectl apply -f applications/consumer/deployment.yml
  ```

* Install Keda helm repo add kedacore https://kedacore.github.io/charts
  ```sh   
  helm repo update kubectl create namespace keda helm install keda kedacore/keda --namespace keda
  ```

* Apply scale object
  ```sh  
  kubectl apply -f keda/ScaledObject.yml
  ```

* Loop requests
  ```sh
  x=1;while true; do curl -X POST "http://localhost:8080/publish/hello$x";echo http://localhost:8080/publish/hello$x; (( x++ )); done
  ```

### Prerequisites

* Clone the project
  ```sh
  git clone https://github.com/natalicot/keda-demo-project.git
  cd keda-demo-project
  ```

<!-- ROADMAP -->

## Roadmap

- [ ] Add Podman Support

See the [open issues](https://github.com/natalicot/keda-demo-project/issues) for a full list of proposed features (and
known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any
contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also
simply open an issue with the tag "enhancement". Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTACT -->

## Contact

Natali Cutic - [Natali Cutic](https://www.linkedin.com/in/natali-cutic-24a444157/) - natalicot@gmail.com

Project Link: [https://github.com/your_username/repo_name](https://github.com/your_username/repo_name)

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

* [An awesome README template](https://github.com/othneildrew/Best-README-Template)
* [That devOps guy](https://www.youtube.com/c/MarcelDempers)
* [Sela](https://sela.co.il/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/natalicot/keda-demo-project.svg?style=for-the-badge

[contributors-url]: https://github.com/natalicot/keda-demo-project/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/natalicot/keda-demo-project.svg?style=for-the-badge

[forks-url]: https://github.com/natalicot/keda-demo-project/network/members

[stars-shield]: https://img.shields.io/github/stars/natalicot/keda-demo-project.svg?style=for-the-badge

[stars-url]: https://github.com/natalicot/keda-demo-project/stargazers

[issues-shield]: https://img.shields.io/github/issues/natalicot/keda-demo-project.svg?style=for-the-badge

[issues-url]: https://github.com/natalicot/keda-demo-project/issues

[license-shield]: https://img.shields.io/github/license/natalicot/keda-demo-project.svg?style=for-the-badge

[license-url]: https://github.com/natalicot/keda-demo-project/blob/master/LICENSE.txt

[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555

[linkedin-url]: https://linkedin.com/in/natali-cutic-24a444157

[product-screenshot]: https://media.giphy.com/media/b9JsbL9rf1g1PV0IM8/giphy.gif

[Golang.png]: https://img.shields.io/badge/Golang-V1.19-ff69b4
[Golang-URL]: go.dev

[Kind.png]: https://img.shields.io/badge/Kind-V0.14-ff69b4
[Kind-URL]: kind.sigs.k8s.io

[terraform.png]: https://img.shields.io/badge/Terraform-V1.1.9-ff69b4
[terraform-URL]: terraform.io

[RMQ.png]: https://img.shields.io/badge/RMQ-V3.8-ff69b4
[RMQ-URL]: rabbitmq.com

[Keda.png]: https://img.shields.io/badge/Keda-V2.5-ff69b4
[Keda-URL]: keda.sh

[Docker.png]: https://img.shields.io/badge/Docker-V20.10-ff69b4
[Docker-URL]: docker.io

