function sleep_until_5_past() {
    minutes=`date "+%M"`;
    seconds=`date "+%S"`;
    seconds_until_five_after_the_hour=`echo "3900-$minutes*60-$seconds" | bc`;
    echo "Sleeping until 5 minutes after the hour. ($seconds_until_five_after_the_hour seconds, Starting @ "`date "+%H:%M:%S"`")";
    sleep $seconds_until_five_after_the_hour;
}

