#! /bin/bash
flag=true
flag2=true
ClicktoClear(){
read -p "press enter key to continue" click
clear
}

while $flag
do
	echo "--------------------------------------"
        echo "1)create database "
        echo "2)list database "
        echo "3)connect to database "
        echo "4)drop database "
        echo "5)exit"
	echo "--------------------------------------"
        read -p "please enter your choice: " choice
        case $choice in
                1)
                        read -p "enter the name of the database: " db_name
                        mkdir /home/$USER/bash-project/$db_name
                        mkdir /home/$USER/bash-project/$db_name/constraints_files
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
                                while $flag2
                                do
                                	echo "----------$db_name database-----------"
                                        echo "1)Create Table "
                                        echo "2)List Tables "
                                        echo "3)Drop Table "
                                        echo "4)Insert into Table"
                                        echo "5)Select from Table"
                                        echo "6)Delee from Table"
                                        echo "7)Update Table"
                                        echo "8)back"
                                        echo "9)exit"
					echo "--------------------------------------"
                                        read -p "Please Enter your choice: " db_action
                                        case $db_action in	#create table
                                                1) echo "$db_action" #Create table
                                                        read -p "Enetr the name of the table: " table_name
                                                        if [[ -e $table_name ]]
                                                        then
                                                                echo "$table_name Already Exists"
                                                        else
                                                                touch $table_name
								#echo "Enter the fields name (e.g(name1 name2 name3)) "
								#read  -a attributes
                                                		#split($attributes, fsplit, ",")
								#echo $fsplit[@] > $table_name
								#echo $(IFS=:; echo "${attributes[*]}") >> $table_name
								#constraints
								declare -a const	#constraints
								declare -a att		#attributes
								unset const
								unset att
								#const[0]=$table_name
								esc="y"
								#typeset -i i=0
								i=0
								while [[ $esc == "y" ]]
								do
									echo "Enter the attribute name: "
									read att[$i]
									echo "Enter the corresponding constraint:"
									read const[$i]
									echo "do you wan to add more fields(y/n): "
									read esc
									((i++))

								done
								echo $(IFS=:; echo "${att[*]}") >> $table_name
								echo $(IFS=:; echo "${const[*]}") > constraints_files/$table_name
								echo $(IFS=:; echo "${att[*]}") >> constraints_files/$table_name
								cat constraints_files/$table_name
                                                                echo "table created successfully !!"
                                                        fi
                                                        ClicktoClear
                                                ;;
                                        2) echo "$db_action" #list table
                                                if [ "$( ls -p | egrep -v /$ )" ]
                                                then
                                                       	ls -p | egrep -v /$
                                                else
                                                        echo "There are no tables in this DataBase"
                                                fi
                                                ClicktoClear
                                                ;;
                                        3) echo "$db_action" #drop table
                                                        read -p "Enter the name of the table: " table_name
                                                        if [[ -e $table_name ]]
                                                        then
                                                                rm $table_name
								rm constraints_files/$table_name
                                                                echo "$table_name has been deleted"
                                                        else
                                                                echo "$table_name not found"
                                                        fi
                                                        ClicktoClear
                                                        ;;
                                        4) echo "$db_action"     #Insert
                                                read -p "Enter the  Table name : " table_name
                                                if [[ -e $table_name ]]
                                                then
							declare -a array
                                                	unset array[@]
							unset const
                                                	IFS=':' read -ra all_fields < $table_name 	#read attributes from file
                                                	#temp=`tail -n 1 constraints_files/$table_name`
                                                	IFS=':' read -ra const < constraints_files/$table_name 	#read attributes from file
							#IFS=':' read -ra const < $temp #read attributes from file
							echo ${const[@]}
							#read -p "enter the ${all_fields[0]} )" array[0]
							#set -x
                           	               		for ((i=0;i<${#all_fields[@]};i++))
                                	                do
								read -p "enter the  ${all_fields[i]} )" element
								if [[ ${const[$i]} == "int" ]]
								then
									#case $element in 
									#	*([[:alnum:]]) ) echo "Number"
									#		;;
									#		
									#	*) echo "wrong input data type"
									#		break
									#		;;
									#esac
									if [[ $element =~ ^[0-9]+$ ]]
									then
										echo "Number"
									else
										break
									fi
								elif  [[ ${const[$i]} == "char" ]]
								then
									if [[ $element =~ ^[0-9]*\.?[0-9]+$ ]]
                                                                        then
                                                                                break
                                                                        else
                                                                                echo "alpha"
                                                                        fi
								elif [[ ${const[$i]} == "float" ]]
                                                                then
                                                                        if [[ $element =~ ^[0-9]*\.?[0-9]+$ ]]
                                                                        then
                                                                                echo "float"
                                                                        else
                                                                                break 
									fi
 

									#case $element in 
                                                                        #*([[:alpha:]]) ) echo "alpha"
									#	;;
									#
									#*) echo "wrong input data type"
									#	break
									#	;;
									#esac
								fi
								#array=("${array[@]}"":$element")
        	                                        
								array[$i]=$element
							done

							#set +x
							
							if [[ ${#array[@]} -eq ${#all_fields[@]} ]]
							then

                	                                	array_a=$(IFS=:; echo "${array[*]}")
								echo "${array_a[@]}" >> $table_name
							else
								echo "couldn't insert"
							fi
						else
							echo "Table doesn't exist (create table first)"
						fi
                        	                ClicktoClear
                                	                ;;

                                        5) echo "$db_action" 	#Select
                                                read -p "Enter the  Table name : " table_name
                                                #declare -a desired_fields
						echo "Enter the fields: (e.g (name1 name2 name3) )"
						read -a desired_fields
						declare -a last_fields
                                                #desired_index=$(IFS=,; echo "${desired_fields[*]}") #serialization into one string to pass it to the awk then we will split it inside of the awk
						unset last_fields[@]
						IFS=':' read -ra all_fields < $table_name
						for ((i=0;i<${#desired_fields[@]};i++))
						do
							for ((j=0;j<${#all_fields[@]};j++)) 
							do
								if [[ ${desired_fields[i]} == ${all_fields[j]}  ]]
								then
									#echo $j #debugging
									last_fields=("${last_fields[@]}" "$(($j+1))")
									#echo ${last_fields[@]} #debugging

								fi
							done
						done

                                                #desired_fields=(1 3 5)
                                                #echo "Enter the field numbers to print (e.g., 1 3 5):"
                                                #read -a desired_fields
                                                index=$(IFS=,; echo "${last_fields[*]}") #serialization into one string to pass it to the awk then we will split it inside of the awk
						desired_fields_s=$(IFS=,; echo "${desired_fields[*]}")
						#echo $desired_fields_s #for devugging

						f_count=${#desired_fields[@]}
						 
						
						#set -x
						awk -F: -v fields="$index" -v headline="$desired_fields_s" -v total_length=15 -v fields_count="$f_count" 'BEGIN {printf "%s", "+";for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""; printf "|" ;split(headline, h, ",") ;for (i in h) {padding=total_length-length(h[i]);right=int(padding/2);left=padding-right; printf "%*s%s%*s|",left, "", h[i],right,"" };print""; printf "%s", "+"; for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""} {if(NR != 1){printf "%s", "|"; split(fields, f, ",") ; for (i in f) {padding=total_length-length($f[i]);right=int(padding/2);left=padding-right; printf "%*s%s%*s|",left, "", $f[i],right,"" } ; print"" }} END{printf "%s","+" ;for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""}' "$table_name"
	
						#set +x
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
