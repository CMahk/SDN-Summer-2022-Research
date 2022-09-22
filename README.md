# SDN 2022 Summer Research
## Introduction
This is a repository for my NC4 research while working with the DoD

The focus of this research is to find better solutions for SDN resilience, specifically when using ONOS controllers

This repository includes the following:
* An environment setup script
* Scripts to create multi-controller instances and various functionalities for them
* Wireshark packets displaying how quickly controllers discover failed instances
* A BFD script to be installed on Mininet switches, with additional scripts to help configure test enviroments using the BFD module

## What was Done?
- [x] Added multi-controller functionality and inter-controller communication via Mininet
- [x] Changed from the Heartbeat protocol to the SWIM protocol to increase controller failure detection at a more reliable rate

## What is Next?
- [ ] Controllers take 8 seconds after detecting a failure to take over for the failed controller. How can we decrease the time this takes?
- [ ] Further testng between multi-controller instances using Mininet and the BFD module installed on each switch to create a holistically resilient network

## Links
Manual on how to setup and start researching: https://docs.google.com/document/d/1B6RVjKizU73wON1MSZZahgHgvYrIIOY2o9LIlf8ouPo

## Original 2021 SDN Research Repo
https://github.com/coalvoltage/SDN_2021_Summer_Research
