#!/bin/bash

# usage: oo.sh action [job ID / username]

# example:
#    oo.sh rw              -- use ./coordinator.properties to run and watch a job
#    oo.sh kill <job-id>   -- kill a specific job
#    oo.sh watch <job-id>  -- watch a specific job every 15 seconds
#    oo.sh log <job-id>    -- print log from oozie server for a specific job
#    oo.sh live <username> -- check running job started by user
#    oo.sh dryrun (dr)     -- use ./coordinator.properties to dryrun
#    oo.sh run (r)         -- use ./coordinator.properties to run
#    oo.sh validate        -- validate app/workflow.xml and app/coordinator.xml

source ~/.bashrc
#set -e
function get_oozie_server {
    # detect oozie server according to namenode
    OOZIE_SERVER=http://<oozie_server_ip>:11000/oozie/
}

function just_run_job {
    oozie job -run -config coordinator.properties -oozie $OOZIE_SERVER
    #oozie job -run -config coordinator.properties -oozie $OOZIE_SERVER -auth KERBEROS
}

function just_test_job {
    oozie job -run -config test.properties -oozie $OOZIE_SERVER
    #oozie job -run -config coordinator.properties -oozie $OOZIE_SERVER -auth KERBEROS
}

echo "detecting oozie server"
get_oozie_server
echo "Current Oozie server : $OOZIE_SERVER"

ACTION=$1
JOBID=$2

if  [[ X"" != X"$2"  &&  $1 = "live" ]]  ;
    then USER=$2
else
    USER=`whoami`
fi

ALERT_FOR_TEST=yes
TEST_CONFIG=0
if [[ -f test.properties ]]
then
    TEST_CONFIG=1
fi

function validate () {
    oozie validate workflow.xml
    oozie validate coordinator.xml
}

function check_live_job () {
    echo "RUNNING coordinator jobs started by $USER"
    oozie jobs -jobtype coordinator -len 1000 -filter "user=$USER;status=RUNNING" --oozie $OOZIE_SERVER
    #oozie jobs -jobtype coordinator -len 1000 -filter "user=$USER;status=RUNNING" --oozie $OOZIE_SERVER  -auth KERBEROS
    echo "RUNNING WITH ERROR coordinator jobs started by $USER"
    oozie jobs -jobtype coordinator -len 1000 -filter "user=$USER;status=RUNNINGWITHERROR" --oozie $OOZIE_SERVER
    #oozie jobs -jobtype coordinator -len 1000 -filter "user=$USER;status=RUNNINGWITHERROR" --oozie $OOZIE_SERVER -auth KERBEROS
}

function check_all_job () {
    echo "all coordinator jobs started by $USER"
    oozie jobs -jobtype coordinator -len 1000 -filter "user=$USER" --oozie $OOZIE_SERVER
    #oozie jobs -jobtype coordinator -len 1000 -filter "user=$USER" --oozie $OOZIE_SERVER  -auth KERBEROS
}

function dryrun_job () {
    project=`pwd | awk -F"/" '{print $NF}'`
    grid_workflow_dir=`sed -n -e 's/\(oozie.coord.application.path=\)\(.*\)/\2/p' coordinator.properties`

    hadoop --config ${HADOOP_CONF_DIR} fs -rm -r ${grid_workflow_dir?}
    hadoop --config ${HADOOP_CONF_DIR} fs -mkdir -p ${grid_workflow_dir?}
    hadoop --config ${HADOOP_CONF_DIR} fs -put ./* ${grid_workflow_dir?}

    #oozie job -dryrun -config coordinator.properties -oozie $OOZIE_SERVER -auth KERBEROS
    oozie job -dryrun -config coordinator.properties -oozie $OOZIE_SERVER

    if [ $? -ne 0 ]
    then
        oozie  job -dryrun -config coordinator.properties -oozie $OOZIE_SERVER
    fi
}

function run_job () {
    if [[ $TEST_CONFIG -ne 0 && "a"$ALERT_FOR_TEST -eq "ayes" ]]
    then
        read -p "This will overwrite production hdfs files, are you sure to continue? (y|yes or n|no) " confirm
        if [[ $confirm != 'yes' && $confirm != 'y' ]]
        then
            echo "did not start the job."
            return
        fi
    fi
    project=`pwd | awk -F"/" '{print $NF}'`
    grid_workflow_dir=`sed -n -e 's/\(oozie.coord.application.path=\)\(.*\)/\2/p' coordinator.properties`

    hadoop --config ${HADOOP_CONF_DIR} fs -rm -r ${grid_workflow_dir?}
    hadoop --config ${HADOOP_CONF_DIR} fs -mkdir -p ${grid_workflow_dir?}
    hadoop --config ${HADOOP_CONF_DIR} fs -put ./* ${grid_workflow_dir?}

    just_run_job

    if [ $? -ne 0 ]
    then
        just_run_job
    fi
}

function test_job () {
    project=`pwd | awk -F"/" '{print $NF}'`
    grid_workflow_dir=`sed -n -e 's/\(oozie.coord.application.path=\)\(.*\)/\2/p' test.properties`

    hadoop --config ${HADOOP_CONF_DIR} fs -rm -r ${grid_workflow_dir?}
    hadoop --config ${HADOOP_CONF_DIR} fs -mkdir -p ${grid_workflow_dir?}
    hadoop --config ${HADOOP_CONF_DIR} fs -put ./* ${grid_workflow_dir?}

    just_test_job

    if [ $? -ne 0 ]
    then
        just_test_job
    fi
}

function kill_job() {
    #oozie job -kill $JOBID --oozie $OOZIE_SERVER -auth KERBEROS
    oozie job -kill $JOBID --oozie $OOZIE_SERVER 
}

function show_job_log {
    #oozie job -log $JOBID -oozie $OOZIE_SERVER -auth KERBEROS
    oozie job -log $JOBID -oozie $OOZIE_SERVER 
    if [ $? -ne 0 ]
    then
        oozie job -info $JOBID -oozie $OOZIE_SERVER
    fi
}

function check_job {
    #oozie job -info $JOBID -oozie $OOZIE_SERVER -auth KERBEROS
    oozie job -info $JOBID -oozie $OOZIE_SERVER 
    if [ $? -ne 0 ]
    then
        oozie job -info $JOBID -oozie $OOZIE_SERVER
    fi
}

function watch_job {
    #oozie job -info $JOBID -oozie $OOZIE_SERVER -auth KERBEROS
    oozie job -info $JOBID -oozie $OOZIE_SERVER 

    if [ $? -ne 0 ]
    then
        oozie job -info $JOBID -oozie $OOZIE_SERVER
    fi

    #watch -n 15 -d "oozie job -info $JOBID -oozie $OOZIE_SERVER -auth KERBEROS"
    watch -n 15 -d "oozie job -info $JOBID -oozie $OOZIE_SERVER"
}

function run_and_watch_job {
    JOBID=`run_job | tail -n 1 | sed -e "s/job: \(.*\)/\1/g"`
    watch_job
}



case "$ACTION" in
    # run
    "rw") run_and_watch_job
    ;;
    "run") run_job
    ;;
    "r") run_job
    ;;
    "t"|"test") test_job
    ;;
    "jt"|"just_test") just_test_job
    ;;
    "jr") just_run_job
    ;;
    "dryrun") dryrun_job
    ;;
    "dr") dryrun_job
    ;;
    "validate") validate
    ;;

    # kill
    "kill") kill_job
    ;;
    "k") kill_job
    ;;

    # watch
    "watch") watch_job
    ;;
    "w") watch_job
    ;;
    "check") check_job
    ;;

    # check status
    "log") show_job_log
    ;;
    "live") check_live_job
    ;;
    "alllive") check_all_job
    ;;
esac



