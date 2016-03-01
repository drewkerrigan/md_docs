% CTC Report - RiakCS (Draft)
% Basho Technologies, LLC
% July, 2013
Jon Glick [\<jglick@basho.com\>](mailto:jglick@basho.com)

### Riak CS 1.3.2 Benchmark Report

### Introduction

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur at pharetra libero, vitae facilisis enim. Duis a sapien quis felis sagittis lacinia. In fermentum tristique aliquam. Vivamus lorem urna, ullamcorper et ipsum scelerisque, condimentum varius dui. Nunc sed aliquam ante, non aliquet leo. Nunc pharetra neque ut felis egestas placerat. Aenean elementum dui nec urna gravida hendrerit. Aenean blandit sollicitudin pretium.

### Setup

#### Hardware Setup

The tests were performed on our SoftLayer CTC Cluster, with 14 units of the following:

* SuperMicro X9DRI-LN4F+
* Processor: Intel Xeon E5-2650-OctoCore 2GHz
* RAM: 4x4GB DDR3 (16GB Total)
* RAID Controller: Adaptec 71605 SATA/SAS RAID
* HDD: 2x200GB Smart XceedIOPS SSD (Mirrored)

#### Cluster Configuration

* 1 Management Node, performing the automation
* 3 Benchmark Nodes, running Basho_Bench
* 10 Node Cluster:
	* 1 Riak/RiakCS/Stanchion Node
	* 9 Node Riak/RiakCS Nodes

#### Server Configuration
Standard linux performance tunings were made to the systems.
Please see [http://docs.basho.com/riak/latest/cookbooks/Linux-Performance-Tuning/](http://docs.basho.com/riak/latest/cookbooks/Linux-Performance-Tuning/) for more information.

#### Software Configuration

Standard Riak and Riak CS performance tunings were made. Please see [http://docs.basho.com/riakcs/latest/cookbooks/configuration/Configuring-Riak/](http://docs.basho.com/riakcs/latest/cookbooks/configuration/Configuring-Riak/) for more information.

NOTE: Changes to port numbers, IPs, hostnames, admin keys not listed.

##### Riak Configuration:

* `/etc/riak/vm.args` changes:
	* +swt very_low
	* +zdbbl 65536
	* -kernel net_ticktime 10

* `/etc/riak/app.config` changes:
	* `{ring_creation_size, 256 }`
	* `{enable_health_checks, true}`
	* Standard RiakCS Backend Config
	* Removed: `{fsm_limit, 50000}`
	* `{vnode_mailbox_limit, {1, 5000}}`
	
	Note: 1.3.1 healthcheck configurations were used in 1.3.2
		TODO: Remove these, use 1.3.2 versions of the configs

##### Riak CS Configuration:

* `/etc/riak-cs/vm.args` - No Changes

* `/etc/riak-cs/app.config` - No Changes


#### Basho Bench Setup

* Basho Bench was installed and run from 3 systems simultaneously, to overcome network limitations.
* Basho Bench Configuration:
	* proxy setup, listing all 10 IPs on each load generator
	* 12 concurrent connections per load generator
	* Report Interval set to 10

##### Write Configuration:

* Duration: 120Minutes

* Key Generation:
	
```
{key_generator, {int_to_str, {partitioned_sequential_int, 3000000000}}}.
```
	
* Value Generation:
	
```
{value_generator, {function, basho_bench_driver_cs, bigfile_valgen,
                  [[{file_size, 1048576},
                    {ibrowse_chunk_size, 1000000},
                    {max_rate_per_chunk, 100}]]}}.
```

##### Read Configuration:

The load generation systems ran the previous write configuration to populate the cluster prior to performing the read tests.

* Duration: 120Minutes (Max)

* Key Generation:

```
{key_generator, {int_to_str, {partitioned_sequential_int, 240000}}}.
```

### Results:

#### Write Test
**NOTE**: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur at pharetra libero, vitae facilisis enim. Duis a sapien quis felis sagittis lacinia. In fermentum tristique aliquam.

##### Load Generator 1 - Writes
![Load Gen #1 Writes](img/graphs.jpg "Load Gen #1 Writes")

##### Load Generator 2 - Writes
![Load Gen #2 Writes](img/graphs.jpg "Load Gen #2 Writes")

##### Load Generator 3 - Writes
![Load Gen #3 Writes](img/graphs.jpg "Load Gen #3 Writes")

#### Read Test
**NOTE**: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur at pharetra libero, vitae facilisis enim. Duis a sapien quis felis sagittis lacinia. In fermentum tristique aliquam.

##### Load Generator 1 - Reads
![Load Gen #1 Reads](img/graphs.jpg "Load Gen #1 Reads")


##### Load Generator 2 - Reads
![Load Gen #2 Reads](img/graphs.jpg "Load Gen #2 Reads")
##### Load Generator 3 - Reads
![Load Gen #3 Reads](img/graphs.jpg "Load Gen #3 Reads")

### Conclusions

#### Writes

* Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur at pharetra libero, vitae facilisis enim. Duis a sapien quis felis sagittis lacinia. In fermentum tristique aliquam.

#### Reads

* Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur at pharetra libero, vitae facilisis enim. Duis a sapien quis felis sagittis lacinia. In fermentum tristique aliquam.

### Appendix

* Bitcask file deletion for write simulations:

``` bash
#!/bin/bash
cd /opt/riak/bitcask
SELF=$0
while [ -e $SELF ]; do
echo "$SELF exists"
for dir in `ls -1`; do
	if [ -e $dir/bitcask.write.lock ]; then
		for file in `find /opt/riak/bitcask/$dir -name "*.data"`; do
			if grep $file $dir/bitcask.write.lock > /dev/null;then
				echo "Skipping $file" > /dev/null
			else
				echo "Deleting $file" > /dev/null
				rm -f $file
			fi
		done
	fi
done
sleep 10
done
echo "Couldn't find $SELF"
echo "Exiting"
```