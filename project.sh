#! /bin/bash
flag=true
flag2=true
#select choice in "- Create Database" "- List Databases" "- Connect To Databases" "- Drop Database" "- Break"
#do
while $flag
do
        echo "1)Create Database "
        echo "2)List Database "
        echo "3)Connect to Database "
        echo "4)Drop Database "
        echo "5)Exit"
        read -p "Please Enter your choice: " choice
        case $choice in
                1)
                        read -p "enter the name of the database: " db_name
                        mkdir /home/$USER/bash-project/$db_name
                        echo "the db has been created"
                        sleep 5
                        clear
                        ;;
                2) echo "choosed $choice" #lists all the dbs
                        ls /home/$USER/bash-project
                        ;;
                3) echo "choosed $choice"

                        clear
                        echo "choosed $choice"
                while $flag2
                do
                        echo "1)Create Table "
                        echo "2)List Tables "
                        echo "3)Drop Table "
                        echo "4)Insert into Table"
                        echo "5)Select from Table"
                        echo "6)Delee from Table"
                        echo "7)Update Table"
                        echo "8)back"
                        echo "9)exit"
                        read -p "Please Enter your choice: " db_action
                                case $db_action in
                                        1) echo "$db_action"
                                                ;;
                                        2) echo "$db_action"
                                                ;;
                                        3) echo "$db_action"
                                                ;;
                                        4) echo "$db_action"
                                                ;;
                                        5) echo "$db_action"
                                                ;;
                                        6) echo "$db_action"
                                                ;;
                                        7) echo "$db_action"
                                                ;;
                                        8)
                                                flag2=false
                                                clear
                                                ;;
                                        9)
                                                flag2=false
                                                flag=false
                                                ;;
                                        *) echo " choose a number from 1 to 9 "
                                                ;;
                                esac

                        done
                        ;;
                4) echo "choosed $db_action" #drops db
                        read -p "enter the name of the db you want to delete : " db_del
                        rm -rf /home/$USER/bash-project/$db_del
                        ;;
                5) flag=false
                        ;;
                *) echo "choose a number from 1 to 5"
                        ;;
        esac
done
