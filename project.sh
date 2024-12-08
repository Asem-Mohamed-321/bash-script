#! /bin/bash
#echo "- Create Database " 
#echo "- List Databases "
#echo "- Connect To Databases "
#echo "- Drop Database "

select choice in "- Create Database" "- List Databases" "- Connect To Databases" "- Drop Database" "- Break"
do

        case $REPLY in
                1)
                        read -p "enter the name of the database: " db_name
                        mkdir /home/asem/bash-project/$db_name
                        echo "the db has been created"

                        ;;
                2) echo "choosed $REPLY" #lists all the dbs
                        ls /home/asem/bash-project
                        ;;
                3) echo "choosed $REPLY"

                        clear
                        echo "choosed $REPLY"
                        select db in "- Create Table" "- List Tables" "- Drop Table" "- Insert into Table" "- Select From Table" "- Delete From Table"  "- Update Table" "- Back "
                        do
                                case $REPLY in
                                        1)
                                                echo "$REPLY"
                                                ;;
                                        2) echo "$REPLY"
                                                ;;
                                        3) echo "$REPLY"
                                                ;;
                                        4) echo "$REPLY"
                                                ;;
                                        5) echo "$REPLY"
                                                ;;
                                        6) echo "$REPLY"
                                                ;;
                                        7) echo "$REPLY"
                                                ;;
                                        8)
                                                clear
                                                echo "1) - Create Database" 
                                                echo "2) - List Databases"
                                                echo "3) - Connect To Databases "
                                                echo "4) - Drop Database" 
                                                echo "5) - Break"
                                                break
                                                ;;
                                        *) echo " choose a number from 1 to 8 "
                                                ;;

                                esac

                        done
                        ;;
                4) echo "choosed $REPLY" #drops db
                        read -p "enter the name of the db you want to delete : " db_del
                        rm -r /home/asem/bash-project/$db_del
                        echo $?
                        ;;
                5) break
                        ;;
                *) echo "choose a number from 1 to 5"
                        ;;
        esac
done
