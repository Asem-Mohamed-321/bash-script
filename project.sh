#! /bin/bash
flag=true
flag2=true
ClicktoClear(){
read -p "Press Enter key to continue" click
clear
}

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
                        ClicktoClear
                        ;;
                2) echo "choosed $choice" #lists all the dbs
                        if [ "$(ls -A)" ]
                        then
                                ls /home/$USER/bash-project
                        else
                                echo "There are no DataBase found"
                        fi
                        ClicktoClear
                        ;;
                3) echo "choosed $choice"       #connect to database
                        read -p "Enter DataBase name: " db_name
                        if [[  -e "/home/$USER/bash-project/$db_name" ]]
                        then
                                cd /home/$USER/bash-project/$db_name
                                clear
                                echo "--------$db_name database-------"
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
                                                1) echo "$db_action" #Create table
                                                        read -p "Enetr the name of the table: " table_name
                                                        if [[ -e $table_name ]]
                                                        then
                                                                echo "$table_name Already Exists"
                                                        else
                                                                touch $table_name
                                                                echo "table created successfully !!"
                                                        fi
                                                        ClicktoClear
                                                ;;
                                        2) echo "$db_action" #list table
                                                if [ "$(ls -A )" ]
                                                then
                                                        ls
                                                else
                                                        echo "There are no tables in this DataBase"
                                                fi
                                                ClicktoClear
                                                ;;
                                        3) echo "$db_action" #drop table

                                                        read -p "Enetr the name of the table: " table_name
                                                        if [[ -e $table_name ]]
                                                        then
                                                                rm $table_name
                                                                echo "$table_name has been deleted"
                                                        else
                                                                echo "$table_name not found"
                                                        fi
                                                        ClicktoClear
                                                        ;;
                                        4) echo "$db_action"
                                                read -p "Enter the  Table name : " table_name

                                                declare -a array
                                                unset array[@]
                                                read -p "enter the element no 1)" array[0]

                                                for ((i=1;i<5;i++))
                                                do
                                                        read -p "enter the element no $(($i+1))" element
                                                        array=("${array[@]}"":$element")

                                                done
                                                echo "${array[@]}" >> $table_name
                                                ClicktoClear
                                                ;;

                                        5) echo "$db_action"
                                                read -p "Enter the  Table name : " table_name
                                                declare -a data_index
                                                data_index=(1 3 5)
                                                index=$(IFS=,; echo "${data_index[*]}") #serialization
                                                #len_arr=${#data_index[@]}

                                                set -x
                                                awk -F: 'BEGIN {printf "%s", "+";for(i=0;i<16;i++) printf "%s","-";print"+" ;print "|name|  idk  |lst|"; printf "%s", "+";for(i=0;i<16;i++) printf "%s","-";print"+" } {printf "%s", "|"; n = split("'"$index"'", index, ",") ; for (i=1;i<n;i++) printf  index[i] "|"; print"" } END{printf "%s","+" ;for(i=0;i<16;i++) printf "%s","-" ;print"+"}' "$table_name"
                                                set +x
                                                ClicktoClear
                                        ;;
                                        6) echo "$db_action"
                                                ;;
                                        7) echo "$db_action"
                                                ;;
                                        8)
                                                cd -
                                                flag2=false
                                                clear
                                                ;;
                                        9)
                                                cd -
                                                flag2=false
                                                flag=false
                                                ;;
                                        *) echo " choose a number from 1 to 9 "
                                                ;;
                                esac
                        done
                else
                        echo "database not found"
                        ClicktoClear
                fi
                        ;;
                4) echo "choosed $choice" #drops db
                        read -p "enter the name of the db you want to delete : " db_del
                        if [[ -e $db_del ]]
                        then
                                rm -rf /home/$USER/bash-project/$db_del
                                echo "$db_del has been deleted successfully !!"
                        else
                                echo "$db_del not found"
                        fi
                        ClicktoClear
                        ;;
                5) flag=false
                        ;;
                *) echo "choose a number from 1 to 5"
                        ClicktoClear
                        ;;
        esac
done
~               
