
# About the project                                                                           

  The base line of tests are formed following those steps: 
  * unit test - the isolated test designed to assert single method only. Any dependencies would be mocked.
  * integration test - forms the dependencies test. Once unit test is complete, the integration asserts only the dependent internal/external connects. If MVC pattern is used, the controller would be the target. Most times, only the little amount of tests are required for this section. 
  * Functional test - an E2E test approach using interface designed to assert business functional requirements. Was the feature (functional bsuiness requirement) implemented and ticked all behavior requiremenets.
    * it is common to use integration test as the monitoring interface to report the test asserts
  * Performance test - it's a type of test, designed to identify weak points, called **bottle neck**.

  Provided test format can be applied in all industries, however this dockerised environment designed to test web or app levels only.

## Baseline forming test application bundle
  * https://nightwatchjs.org - main cross brwoser e2e test environemnt, including integration, unit test and mobile devices 
  * https://github.com/giltene/wrk2 - at this point docker uses `wrk`, however this page explains both versions and contains better documentation 
  * https://www.selenium.dev - Selenium WebDriver, IDE and GRID are the main tools which makes all this test environement possible
  * https://chromedriver.chromium.org - ChromeDriver; one of virtualised browser platform (each browser today has their own headless drivers)
  * https://www.docker.com - OS isolation and virtualisation application

---

# Test application 
  Many test tools today provide simmilar functinality, but not many tools are capable to bind all test methodolgies in single working space.
  Above listed products are free to use. Here, they simply bundled together to gain out of the box work experience. 

## About NightWatch - Web, mobile native, full scale test 
  * One framework for all platforms
  * Mobile webTest on your web apps on real mobile devices, and scale easily by connecting to cloud grids
  * Native mobileTest your native iOS and Android apps with Nightwatch
  * Real desktop browsersTest on real browsers which accurately reflect your users’ environment
  
## Dockerised launch pad 
  One missing tools by NightWatch is a **stress analysis** test. Due to the nature of the service, some extra conditions has to be controlled on demand to gain required accuracy. As a result, docker forms a service bundle designed to handle all test methodologies: 
  * chrome - a default browser for e2e/functional test
    * embeded Selenium Grid Web interface can be uised to observe running test sessions
      * default location: `http://localhospt:4444/`
    * VNC remote screen also available 
      * default location `localhost:5900`
  * chrome_video - a selenium stream pipeline designed to record test to a video file.
    * TODO: make this service optional and/or used only to record failed tests 
  * benchmark - a WRK api performance test tool
    * be aware of the docker-compose setup. To test more threads, total amount of CPU has to be increased
    * complex and reusable test can be scripted using LuaJIT located at `./project/performance/`
      * https://www.lua.org/about.html
  * project - the work place for all NightWatch tests except WRK
    * e2e sample test file placed and with little modification can be re-used for internal projects
    * located `./project/e2e/`
      * `results` directory contains serialised results tests summary in HTML format 
    * ab - Apache benchmark tool placed for quick endpoint benchmarking
      * sample located at `MOM.sh`
    * for quick REST API prototyping, node API project also located here 
  * TODO - include virtualised mobile app test

## Project control
  To simplify the project control, **Mission Operation Management (MOM)** shell UI interface is placed in for a Linux terminal users. 
  File `MOM.sh`
  Execute `sh MOM.sh` and follow available options. 

	All project was test using Ubuntu kernel and intern install and configuration scripts are tailored to Debian. 
  
### Start project

Menu options:
  * 1 "Start project"
  * 2 "Build project"
  * 3 "Install Docker"
  * 5 "Monior running containers"
   
	If clean environement is used, probably best approach would be to follow options in sequence `3`, `2`, `1`.

	To observe running containers and harware parameters ussage, option `5` tailored to help. 

----

Menu options:

  * 10 "Shell: benchmark container"
	* 11 "Shell: project (e2e) container + AB"

  Quick access to containers where all dev work most likely will be triggered.

----

Menu options:

  * 20 "LOG: benchmark container"
	* 21 "LOG: project (e2e) container"

  Native Docker fork to access logs.  

----

Menu options:

  * 40 "TEST: sample WRK benchmark"
	* 41 "TEST: sample e2e"
	* 42 "TEST: sample Apache benchmark"

  This space provides the example how to trigger test outside running docker container. 
  For more complex project, like `smoke tests`, menu can be extended at your convenience.

----

Menu options:

  * 50 "Docker: clear cache"
  * 51 "Host: restart"
 
  Useful DevOps commands

 
# Test environement 
 
  To make project test compliant, some strategies are advisable to be incorporated in project planning: 
  * test drivven development - the approach, where tests are written prior implementation. Such strategy usually requires an architect and senior developer to form the project baseline
  * auto unit test schema rendering - a very convenient approach to reduce test schema, so developers would focus on assertions only
  * git hooks - ensures work integrity, by triggering test scripts prior code is pushed to repository
  
  The other case, which has to be taken into consideration is the performance test. At this point we already assume that everything is working as expected, but what is not known, which component will cause the `bottle neck`. 
  This test is not about how big and strong servers are, but where the week points are hidden inside developed application (DB, RAM, CPU, Networking, IO, modules). 

  Docker allows to isolate not just OS and installed applications, but the hardware parameters too. It is advisable to have the minimum unit setup to find out the reasonalble working experience available to end user. Something similar like OS install provides the minimum hardware requirements.
  The other reason why single minimum unit required, is the horisontal scalability. If we know the total coapacity of process unit can handle, we could easily determine how many units we will need for production to handle `n` amount of users.
  WRK work strategy is to provide the load on remote unit, so it is important to separate those environments to avoid competetion for the same resources.  
    * most common single unit setup:  
      * 2 core 4Ghz CPU
      * 8GB RAM 
      * network throughput 100Mb/s
      * SSD - read 500 MB/s
    * test strategy, once it is set, it can't be changed. Otherwise it is not a test if environement can't be controlled or reproduced. 
      * stress analysis can answer:
        * total amount request can be handled per second within expected normal load 
        * total amount requests can be handle per second during heavy load  
        * the break point in case od DDoS attack or too many users 
        * scale point using K8s or other cloud service 
        * are there any cache used
        * even service hart beat 
			* single endpoint test scenarios should consist of the same parameters during all project test. Example bellow:
				* A: 10 requests, test duration 1min
				* B: 100 requests, test duration 1min
		* wrk command line load test sample (P.S. used private project on intranet, so not replicable):
      * `lua` script can be used for production and complex test script
      * `wrk -c10 -d60 -t2 --latency http://192.168.1.10:8000/`
				* -c10 - total established connections 
        * -d60 - test duration time
        * -t2 - the total amount of threads used to cary open concurrent communications 
          * threads used to scale the test to gain required throughput, cause generating load is heavy duty task and test pod requires resourcess too. General rule would be `# CPU core = WRK threads` 
      	  * in this instance, 10 requests was balanced amoung 2 threads, so 5 requests per each CPU core
        * --latency - detailed latency percentile information
      * output:
			```

        --- TEST A
				 2 threads and 10 connections                                      
				Thread Stats   Avg      Stdev     Max   +/- Stdev                 
					Latency    18.47ms    3.11ms  55.97ms   90.81%                  
					Req/Sec   271.90     25.79   303.00     76.42%                  
				Latency Distribution                                              
					 50%   17.19ms                                                  
					 75%   19.06ms                                                  
					 90%   21.25ms                                                  
					 99%   32.91ms                                                  
				32537 requests in 1.00m, 206.60MB read                            
			Requests/sec:    541.62                                             
			Transfer/sec:      3.44MB                                           

      --- TEST B
				2 threads and 100 connections                    
				Thread Stats   Avg      Stdev     Max   +/- Stdev
					Latency   177.60ms   13.50ms 262.30ms   84.14% 
					Req/Sec   282.37     61.52   393.00     65.58% 
				Latency Distribution                             
					 50%  171.63ms                                 
					 75%  183.86ms                                 
					 90%  196.07ms                                 
					 99%  220.98ms                                 
				33760 requests in 1.00m, 214.36MB read           
			Requests/sec:    562.23                            
			Transfer/sec:      3.57MB                          

			```
        * latency distribution explains what percentage of all request has been completed within time window
        * stdev - the over all deviation of gausian distribution 
          * https://en.wikipedia.org/wiki/Standard_deviation
					* https://www.scribbr.com/statistics/standard-deviation/

# Conclusion 

## Quality  

Regardless the test applied to assert the project, the real test starts at project planing stage, called **Architecture**. 

For example: 
  * if function is very complicated and holds more than 1 logical unit, test will become comlicated too. However if project written in test drivven development (TDD) it naturally provides the documentation due to significant amount of annotations used to describe each project. 
  * interchangable objects (adapters, polymorthic) is very advisable programming architecture. It could simplify test by simply eliminating non-related complexity like user authentication. User authentication in many cases is not what we need to test, but like `oAuth` it becomes satelite across all tests. 
  * Integratioon test is much wider concept and usually requires tools like https://opentelemetry.io/ to gain better visual inspection of pathways connections, but to use this tool, the API routing module should be tailored to help the tracking. 
  * Benchamrking could give insight about project much more accurate if used together in sync with metrics aggregator, like https://prometheus.io/

This project delibarelty designed to provide test automation. Incorporation into CI/CD pipeline would be next logical step. 

Git hooks can be used too to ensure that new and old code is tested prior submit to dev branch. 

## Improvements 

Test documentation, CI/CD pipelining, reporting signmals, virtual mobile devices probably the next questions I wll try to answer and include in this projects.

### Source of others greate work and inspirations I used for this project

https://github.com/nightwatchjs-community/nightwatch-docker
https://nitikagarw.medium.com/getting-started-with-wrk-and-wrk2-benchmarking-6e3cdc76555f
https://github.com/wg/wrk
https://github.com/NavInfoNC/visual-wrk

 

 


