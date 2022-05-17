#!/bin/bash


# main loop for runing scripts
main(){
mk-logs
wordcheck
is-installed
check-mullvad




}





# check and see if ~/logs is there if not make it
mk-logs(){

if [[ $(ls ~/logs) == .*No*.  ]]; then


    echo "making log dir"
  $(mkdir ~/logs)
  $(touch ~/logs/mullvad.logs)

fi

}



check-mullvad(){

#a var to run the command
  status=$(mullvad status)
 # If statment to check if mullvad is connected and if not then connect
  if [[ $status  =~ .*Disconnected*. ]]; then

        echo  $status $(date) >> ~/logs/mullvad.logs

        # make mullvad atempt a conecction
        $(mullvad connect)


        #to write to the file to show previous connections
        echo  $status $(date)  >> ~/logs/mullvad.logs
        echo -en '\n' >> ~/logs/mullvad.logs


        echo "couldnt connect retrying in 10 seconds"

        sleep 10

        echo "retrying"
        let "counter=counter+1"


        if [[ $counter > 5 ]]; then
            echo "couldnt establish connection"
            exit
        fi

        check-mullvad

else

    if [[ $status =~ .*Failure*. ]]; then

        echo "check account info"
        echo "check account info" >> ~/logs/mullvad.logs
        echo  $status $(date) >> ~/logs/mullvad.logs


      else


          echo "all good"
          #to write the file to show previous connections
          echo $status $(date)  >> ~/logs/mullvad.logs
          -en '\n' >> ~/logs/mullvad.logs

  fi

fi
}


# to check log files
wordcheck(){
wordcount=$(wc -l ~/logs/mullvad.logs)
limit=40

#echo $wordcount

if [[ $wordcount < $limit ]]; then

        echo $(date) > ~/logs/mullvad.logs
        echo -en '\n' >> ~/logs/mullvad.logs
fi
}



# function to install mullvad
install-mullvad(){

  echo mullvad not found do you want to install?

  echo "yes,no"

  read awns


    if [[ $awns =~ .*yes*. ]]; then

          $(mkdir ~/.tmp-mullvad-install)

          echo "downloading"

          $(cd ~/.tmp-mullvad-install &&\
            wget --no-http-keep-alive -O mullvad.deb \
            https://mullvad.net/en/download/app/deb/latest/
            )

            echo "installing"

          $(sudo dpkg -i ~/.tmp-mullvad-install/mullvad.deb)

          echo "cleaning up"

          $(rm -r ~/.tmp-mullvad-install)


     else
        if [[ $awns =~ .*no.* ]]; then

              echo "Goodbye"
              exit
          else
              echo "plese enter yes or no"
              install-mullvad

       fi
     fi

    echo "Done"
}




is-installed(){
# $check$(ls /bin/ | grep -c mullvad)

if [[ $(ls /bin/ | grep -c mullvad) < 1 ]]; then
  install-mullvad

fi




}












main
