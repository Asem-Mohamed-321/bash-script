#! /bin/bash
flag=true
flag2=true
ClicktoClear(){
read -p "press enter key to continue" click
clear
}

while $flag
do
	choice=$(zenity --list --title="Our DBMS" --column="CHOOSE AN OPERATION" "1)create database" "2)list database" "3)connect to database" "4)drop database" "exit")

	#echo "--------------------------------------"
        #echo "1)create database "
        #echo "2)list database "
        #echo "3)connect to database "
        #echo "4)drop database "
        #echo "5)exit"
	#echo "--------------------------------------"
        #read -p "please enter your choice: " choice
        case $choice in
                "1)create database")
			db_name=$(zenity --entry --title="Creating a new database" --text="enter the name of the database:")
			#read -p "enter the name of the database: " db_name

                        mkdir /home/$USER/bash-project/$db_name
                        mkdir /home/$USER/bash-project/$db_name/constraints_files
			zenity --info --title="Creating a new database" --text="the db has been created successfully"
			#echo "the db has been created"
                        #ClicktoClear
                        ;;
                "2)list database") echo "choosed $choice" #lists all the dbs
                        if [ "$(ls -A)" ]
                        then
                                zenity --info --title="listing the databases" --text="`ls /home/$USER/bash-project`"
                        else
                                zenity --info --title="listing the databases" --text="There are no Databases found"
				#echo "There are no DataBase found"
                        fi
                        #ClicktoClear
                        ;;
                "3)connect to database") echo "choosed $choice"       #connect to database
                        db_name=$(zenity --entry --title="Connect to a database" --text="enter the database name:")
			#read -p "Enter DataBase name: " db_name
                        if [[  -e "/home/$USER/bash-project/$db_name" ]]
                        then
                                cd /home/$USER/bash-project/$db_name
                                clear
                                while $flag2
                                do
					db_action=$(zenity --list --title="$db_name database" --column="CHOOSE AN OPERATION" "1) Create Table" "2) List Tables" "3) Drop Table" "4) Insert into Table" "5) Select from Table" "6) Delee from Table" "7) Update Table" "8) back" "9) exit")

                                	#echo "----------$db_name database-----------"
                                        #echo "1) Create Table"
                                        #echo "2) List Tables"
                                        #echo "3) Drop Table"
                                        #echo "4) Insert into Table"
                                        #echo "5) Select from Table"
                                        #echo "6) Delee from Table"
                                        #echo "7) Update Table"
                                        #echo "8) back"
                                        #echo "9) exit"
					#echo "--------------------------------------"
                                        #read -p "Please Enter your choice: " db_action
                                        case $db_action in	#create table
                                                "1) Create Table") echo "$db_action" #Create table
							table_name=$(zenity --entry --title="Create table" --text="enter the name of the table :")
							#read -p "Enetr the name of the table: " table_name
                                                        if [[ -e $table_name ]]
                                                        then
                                                                zenity --info --title="Create table" --text="$table_name Already Exists"
								#echo "$table_name Already Exists"
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
								#esc="y"
								#typeset -i i=0
								i=0
								while true
								do
									att[$i]=$(zenity --entry --title="Create table" --text="enter the attribute name:")

									#echo "Enter the attribute name: "
									#read att[$i]
									const[$i]=$(zenity --entry --title="Create table" --text="enter the corresponding constraint:")
									#echo "Enter the corresponding constraint:"
									#read const[$i]
									if zenity --question --title="Create table" --text="Do you want to add more fields?"
									then
										((i++))
									else
										break
									fi
									#echo "do you wan to add more fields(y/n): "
									#read esc
									#((i++))

								done
								echo $(IFS=:; echo "${att[*]}") >> $table_name
								echo $(IFS=:; echo "${const[*]}") > constraints_files/$table_name
								echo $(IFS=:; echo "${att[*]}") >> constraints_files/$table_name
								#cat constraints_files/$table_name
                                                                #echo "table created successfully !!"
                                                        fi
                                                        #ClicktoClear
                                                ;;
                                        "2) List Tables") echo "$db_action" #list table
                                                if [ "$( ls -p | egrep -v /$ )" ]
                                                then
                                                       	zenity --info --title="List Tables" --text="`ls -p | egrep -v /$`"
                                                else
                                                        zenity --info --title="List Tables" --text="There are no tables in the database"
							#echo "There are no tables in this DataBase"
                                                fi
                                                #ClicktoClear
                                                ;;
                                        "3) Drop Table") echo "$db_action" #drop table
                                                table_name=$(zenity --entry --title="Drop Table" --text="enter the name of the table :")        
						#read -p "Enter the name of the table: " table_name
                                                        if [[ -e $table_name ]]
                                                        then
                                                                rm $table_name
								rm constraints_files/$table_name
                                                                zenity --info --title="Drop Table" --text="$table_name has been deleted"
                                                        else
                                                                zenity --info --title="Drop Table" --text="$table_name not found"
								#echo "$table_name not found"
                                                        fi
                                                        #ClicktoClear
                                                        ;;
                                        "4) Insert into Table") echo "$db_action"     #Insert
                                                table_name=$(zenity --entry --title="Insert Into Table" --text="enter the name of the table :")
						#read -p "Enter the  Table name : " table_name
                                                if [[ -e $table_name ]]
                                                then
							declare -a array
                                                	unset array[@]
							unset const
                                                	IFS=':' read -ra all_fields < $table_name 	#read attributes from file
                                                	#temp=`tail -n 1 constraints_files/$table_name`
                                                	IFS=':' read -ra const < constraints_files/$table_name 	#read attributes from file
							#IFS=':' read -ra const < $temp #read attributes from file
							#echo ${const[@]}
							#read -p "enter the ${all_fields[0]} )" array[0]
							#set -x
                           	               		for ((i=0;i<${#all_fields[@]};i++))
                                	                do
								element=$(zenity --entry --title="Insert Into Table" --text="enter the  ${all_fields[i]} :")
								#read -p "enter the  ${all_fields[i]} )" element
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
										zenity --error --text="wrong input data type"
										break
									fi
								elif  [[ ${const[$i]} == "char" ]]
								then
									if [[ $element =~ ^[0-9]*\.?[0-9]+$ ]]
                                                                        then
										zenity --error --text="wrong input data type"
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
										zenity --error --text="wrong input data type"
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
								zenity --error --text="couldn't insert"
							fi
						else
							zenity --info --title="Insert Into Table" --text="Table doesn't exist (create table first)"
						fi
                        	                #ClicktoClear
                                	                ;;

                                        "5) Select from Table") echo "$db_action" 	#Select
						table_name=$(zenity --entry --title="Select From Table" --text="Enter the table name :")
                                                #read -p "Enter the  Table name : " table_name
                                                #declare -a desired_fields
						if [[ -e $table_name ]]
						then

						unset desired_fields
						set -f #this line disable "globing" which will allow the use to input the character "*" without converting it 
						desired_fields=$(zenity --entry --title="Insert Into Table" --text="enter the fields : \nthe format should be (name1 name2 name3)")
						#echo "Enter the fields: (e.g (name1 name2 name3) )"
						IFS=" " read -ra desired_fields <<< "$desired_fields"
						#read -a desired_fields


						
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
                                                                        	zenity --error --text="${desired_fields[i]} not found "
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
							condition_arr=$(zenity --entry --title="Select From Table" --text="Enter the condition : \nthe format shoulc be (e.g., salary > 5000) ")

							#echo "Enter the condition (e.g., salary > 5000):"
                                                        #read -a condition_arr
							IFS=" " read -ra condition_arr <<< "$condition_arr"
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
                                                                        zenity --error --text= "${condition_arr[0]} not found in table"
                                                                        #break
                                                                fi
								
								echo "$condition  ${condition_arr[@]}"
								if [[ ${condition_arr[1]} == "=" ]]
								then
									condition_arr[1]="=="
								fi

							else
							#	zenity --error --text="condition_arr is empty"
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
							zenity --info   --title="Select From Table" --text="<tt>`awk -F: -v fields="$index" -v headline="$desired_fields_s" -v total_length=15 -v fields_count="$f_count" 'BEGIN {printf "%s", "+";for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""; printf "|" ;split(headline, h, ",") ;for (i in h) {padding=total_length-length(h[i]);right=int(padding/2);left=padding-right; printf "%*s%s%*s|",left, "", h[i],right,"" };print""; printf "%s", "+"; for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""} { if ( NR != 1 && '"$condition_f"' ) { printf "%s", "|"; split(fields, f, ",") ; for (i in f) {padding=total_length-length($f[i]);right=int(padding/2);left=padding-right; printf "%*s%s%*s|",left, "", $f[i],right,"" } ; print"" } }  END{printf "%s","+" ;for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""}' "$table_name" `</tt>" 
                                                	#set +x


						fi
					else
						zenity --error --text="$table_name doesn't exist"
					fi

                                                #ClicktoClear
                                        ;;
                                        "6) Delee from Table") echo "$db_action"	#delete

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
                                        "7) Update Table") echo "$db_action"	#update
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
						if [[ ${#desired_fields[@]} -eq 0 || "${desired_fields[0]}" == '*' ]]  #update the whole table if he entered nothing or "*"
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
						
						declare -a const
						unset const
                                                IFS=':' read -ra const < constraints_files/$table_name 	#read attributes from file
						right_datatype=true
						echo $last_fields
						echo $const[@]
						echo ${const[(($last_fields-1))]}

						if [[ ${const[(($last_fields-1))]} == "int" ]]
						then
								if [[ $value =~ ^[0-9]+$ ]]
								then
									echo "Number"
								else
									echo "wrong data type of the column"
									right_datatype=false
								fi
						elif  [[ ${const[(($last_fields-1))]} == "char" ]]
						then
								if [[ $value =~ ^[0-9]*\.?[0-9]+$ ]]
                                                                then
									echo "wrong data type of the column"
                                                                        
									right_datatype=false
                                                                else
                                                                        echo "alpha"
                                                		fi
						elif [[ ${const[(($last_fields-1))]} == "float" ]]
                                                then
                                                                if [[ $value =~ ^[0-9]*\.?[0-9]+$ ]]
                                                                then
                                                                        echo "float"
                                                                else
									echo "wrong data type of the column"
									right_datatype=false
                                                                        
								fi
 
						fi


						set +f #re-enabling globing


						if [[ $found == true && $right_datatype == true ]]
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
					"8) back")
                                                cd -
                                                flag2=false
                                                clear
                                                ;;
					"9) exit")
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
                "4)drop database") echo "choosed $choice" #drops db
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
                "exit") flag=false
                        ;;
                #*) echo "choose a number from 1 to 5"
                #        ClicktoClear
                #        ;;
        esac
done
~                                                                                                                    
