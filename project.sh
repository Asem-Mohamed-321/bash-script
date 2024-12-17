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

						unset desired_fields
						set -f #this line disable "globing" which will allow the use to input the character "*" without converting it 
						echo "Enter the fields: (e.g (name1 name2 name3) )"
						read -a desired_fields


						
						declare -a last_fields
						unset last_fields[@] #the column numbers which will be passed to the awk
						unset all_fileds[@]
						IFS=':' read -ra all_fields < $table_name

						if [[ ${#desired_fields[@]} -eq 0 || "${desired_fields[0]}" == '*' ]]  #view the whole table if he entered nothing or "*"
						then
							for((i=0;i<${#all_fields[@]};i++))
							do
								last_fields=("${last_fields[@]}" "$(($i+1))")
								IFS=':' read -ra desired_fields < $table_name

							done
							found=true

						else       # for specifing some of the columns
							for ((i=0;i<${#desired_fields[@]};i++))
                                                	do
                                                        	found=false
                                                        	for ((j=0;j<${#all_fields[@]};j++))
                                                        	do
                                                                	if [[ ${desired_fields[i]} == ${all_fields[j]}  ]]
                                                                	then
                                                                        	#echo $j #debugging
                                                                        	last_fields=("${last_fields[@]}" "$(($j+1))")
                                                                        	#echo ${last_fields[@]} #debugging
                                                                        	found=true
                                                                	fi
                                                        	done
                                                                	if [[ $found == false ]]
                                                                	then
                                                                        	echo "${desired_fields[i]} not found "
                                                                        	break
		
                                                            		fi
                                                	done

						
						fi

						set +f #re-enabling globing

                                                #desired_index=$(IFS=,; echo "${desired_fields[*]}") #serialization into one string to pass it to the awk then we will split it inside of the awk

						if [[ $found == true ]]
						then

							#desired_fields=(1 3 5)
                                                	#echo "Enter the field numbers to print (e.g., 1 3 5):"
                                                	#read -a desired_fields
							declare condition_arr
							unset condition_arr
							condition=""
							echo "Enter the condition (e.g., salary > 5000):"
                                                        read -a condition_arr
							condition_flag=false
							if [[ ${#condition_arr[@]} -ne 0  ]]
                            		                then
								for ((j=0;j<${#all_fields[@]};j++))
                                                       		do
                                                                	if [[ ${condition_arr[0]} == ${all_fields[$j]} ]]
                                                                        then
										condition=$(($j+1))
										condition_flag=true
										break
                                                                        fi
                                                        	done
								if [[ $condition_flag == false ]]
                                                                then
                                                                        echo "${condition_arr[0]} not found in table"
                                                                        #break
                                                                fi
								
								echo "$condition  ${condition_arr[@]}"
								if [[ ${condition_arr[1]} == "=" ]]
								then
									condition_arr[1]="=="
								fi

							else
								echo "condition_arr is empty"
                                                        	#condition_flag=false
								condition=0
									
                                               		fi

							#for ((j=0;j<${#all_fields[@]};j++))
                                                        #do
								#if $condition_arr
                                                                #then
                                                                        #if [[ ${condition_arr[0]} == ${all_fields[$j]} ]]
									#then
										#condition=$j
									#fi
								#fi
                                                        #done


							
							index=$(IFS=,; echo "${last_fields[*]}") #serialization into one string to pass it to the awk then we will split it inside of the awk
                                                	desired_fields_s=$(IFS=,; echo "${desired_fields[*]}")
                                                	#echo $desired_fields_s #for debugging
                                                	f_count=${#desired_fields[@]}
                                                	#set -x
							condition_f="\$$condition ${condition_arr[1]} ${condition_arr[2]}"
							echo $condition_f
							awk -F: -v fields="$index" -v headline="$desired_fields_s" -v total_length=15 -v fields_count="$f_count" 'BEGIN {printf "%s", "+";for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""; printf "|" ;split(headline, h, ",") ;for (i in h) {padding=total_length-length(h[i]);right=int(padding/2);left=padding-right; printf "%*s%s%*s|",left, "", h[i],right,"" };print""; printf "%s", "+"; for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""} { if ( NR != 1 && '"$condition_f"' ) { printf "%s", "|"; split(fields, f, ",") ; for (i in f) {padding=total_length-length($f[i]);right=int(padding/2);left=padding-right; printf "%*s%s%*s|",left, "", $f[i],right,"" } ; print"" } }  END{printf "%s","+" ;for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""}' "$table_name" 
                                                	#set +x


						fi
                                                ClicktoClear
                                        ;;
                                        6) echo "$db_action"	#delete

						read -p "Enter the  Table name : " table_name
						condition=""
						declare condition_arr
                                                unset condition_arr
                                                
						echo "Enter the condition (e.g., salary >= 5000):"
                                                read -a condition_arr
                                                condition_flag=false

						unset all_fileds[@]
                                                IFS=':' read -ra all_fields < $table_name

                                                if [[ ${#condition_arr[@]} -ne 0  ]]
						then
                    					for ((j=0;j<${#all_fields[@]};j++))
                                                        do
                                                        	if [[ ${condition_arr[0]} == ${all_fields[$j]} ]]
                                                                then
                                                                        condition=$(($j+1))
                                                                        condition_flag=true
                                                                fi
                                                        done
							if [[ $condition_flag == false ]]
                                                        then
                                                        	echo "${condition_arr[0]} not found in table"
                                                            
                                                        fi
                                                                echo "$condition  ${condition_arr[@]}"
                                                	if [[ ${condition_arr[1]} == "=" ]]
							then	
                                                        	condition_arr[1]="=="
							fi

                                                else
                                                        echo "condition_arr is empty"
                                                        #condition_flag=false
                                                fi
						condition_f="\$$condition ${condition_arr[1]} ${condition_arr[2]}"

						awk -F: '{if (NR==1) print$0 ; if(NR!=1 && !('"$condition_f"')) print$0 }' $table_name  > temp && mv temp  $table_name 

                                                ;;
                                        7) echo "$db_action"	#update
						read -p "Enter the  Table name : " table_name
						unset desired_fields
						set -f #this line disable "globing" which will allow the use to input the character "*" without converting it 
						echo "Enter the field: (e.g (name1 name2 name3) )"
						read -a desired_fields
						echo "Enter the value you want to set : "
						read value


						
						declare -a last_fields
						unset last_fields[@] #the column numbers which will be passed to the awk
						unset all_fileds[@]
						IFS=':' read -ra all_fields < $table_name
						if [[ ${#desired_fields[@]} -eq 0 || "${desired_fields[0]}" == '*' ]]  #view the whole table if he entered nothing or "*"
						then
							for((i=0;i<${#all_fields[@]};i++))
							do
								last_fields=("${last_fields[@]}" "$(($i+1))")
								IFS=':' read -ra desired_fields < $table_name

							done
							found=true

						else       # for specifing some of the columns
							for ((i=0;i<${#desired_fields[@]};i++))
                                                	do
                                                        	found=false
                                                        	for ((j=0;j<${#all_fields[@]};j++))
                                                        	do
                                                                	if [[ ${desired_fields[i]} == ${all_fields[j]}  ]]
                                                                	then
                                                                        	#echo $j #debugging
                                                                        	last_fields=("${last_fields[@]}" "$(($j+1))")
                                                                        	#echo ${last_fields[@]} #debugging
                                                                        	found=true
                                                                	fi
                                                        	done
                                                                	if [[ $found == false ]]
                                                                	then
                                                                        	echo "${desired_fields[i]} not found "
                                                                        	break
		
                                                            		fi
                                                	done

						
						fi

						set +f #re-enabling globing


						if [[ $found == true ]]
						then

                                                	condition=""
                                                	declare condition_arr
                                                	unset condition_arr

                                                	echo "Enter the condition (e.g., salary >= 5000):"
                                                	read -a condition_arr
                                                	condition_flag=false

                                                	unset all_fileds[@]
                                                	IFS=':' read -ra all_fields < $table_name

                                                	if [[ ${#condition_arr[@]} -ne 0  ]]
                                                	then
                                                        	for ((j=0;j<${#all_fields[@]};j++))
                                                        	do
                                                                	if [[ ${condition_arr[0]} == ${all_fields[$j]} ]]
                                                                	then
                                                                        	condition=$(($j+1))
                                                                        	condition_flag=true
                                                                	fi
                                                        	done
                                                        	if [[ $condition_flag == false ]]
                                                        	then
                                                                	echo "${condition_arr[0]} not found in table"

                                                        	fi
                                                                	echo "$condition  ${condition_arr[@]}"
                                                        	if [[ ${condition_arr[1]} == "=" ]]
                                                        	then
                                                                	condition_arr[1]="=="
                                                        	fi
							else
                                                        	echo "condition_arr is empty"
                                                        	#condition_flag=false
                                                	fi
                                                	condition_f="\$$condition ${condition_arr[1]} ${condition_arr[2]}"
									
							index=$(IFS=,; echo "${last_fields[*]}") #serialization into one string to pass it to the awk then we will split it inside of the awk
                                                	desired_fields_s=$(IFS=,; echo "${desired_fields[*]}")
                                                	#echo $desired_fields_s #for debugging


							awk -F: '{if (NR==1) print$0 ; if(NR!=1 && '"$condition_f"') {OFS=FS; $'"$last_fields"'="'"$value"'" ;print$0 } else if(NR!=1) {print $0}}' $table_name  > temp && mv temp  $table_name
						fi


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
