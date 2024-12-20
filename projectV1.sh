#! /bin/bash
#--flags to navigate in menu (back or exit)
exit_flag=true
back_flag=true

#--finction to clear the screen(for CLI version)
ClicktoClear(){
read -p "press enter key to continue" click
clear
}
#------main-----#
while $exit_flag
do
    back_flag=true  #to make sure the flag works if the user got back and want to enter a db again
	echo "--------------------------------------"
        echo "1)create database "
        echo "2)list database "
        echo "3)connect to database "
        echo "4)drop database "
        echo "5)exit"
	echo "--------------------------------------"
        read -p "please enter your choice: " choice
        case $choice in
                #creatig database
                1)      
                        read -p "enter the name of the database: " db_name
                        if [[ -e $db_name ]]        #check if database already exists
                        then
                                echo "$db_name Already Exists"
                        else
                            mkdir /home/$USER/bash-project/$db_name                         #creating database directory
                            mkdir /home/$USER/bash-project/$db_name/constraints_files       #creating database constraints files
						    echo "the db has been created"
                        fi
                        ClicktoClear
                        ;;
                #Listing all databases
                2) echo "choosed $choice" #lists all the dbs
                        if [ "$(ls -A /home/$USER/bash-project)" ]                                   #check if there are DBs or not
                        then
                                ls /home/$USER/bash-project                 #bash-project: the folder that contains all the DBs change it as u want
                        else
                                echo "There are no DataBase found"
                        fi
                        ClicktoClear
                        ;;
                #Connect to database
                3) echo "choosed $choice"       
                        read -p "Enter DataBase name: " db_name
                        if [[  -e "/home/$USER/bash-project/$db_name" ]]            #check if DB exists
                        then
                            cd /home/$USER/bash-project/$db_name
                            clear
                            while $back_flag
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
                                case $db_action in	
                                    #Create table
                                    1) 
                	                        read -p "Enetr the name of the table: " table_name
                	                        if [[ -e $table_name ]]                             #check if table already exists
                	                        then
                	                                echo "$table_name Already Exists"
                	                        else
                	                                touch $table_name
											declare -a const	#constraints
											declare -a att		#attributes
											declare -a pk_arr	#Primary key 
											unset pk_arr
											unset const
											unset att
											esc="y"             #flag to ask the user to enter more attributes
											i=0
                                            #read attributes and constraints from user
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
											pk_arr="PK"
											read -p "Enter the Primary key attribute name: " pk_name    #user choose PK
											#creating how th pk stored in the constraints file (PK:pk_name:pk_columnNumber)
                                            for ((i=0;i<${#att[@]};i++))
											do
												if [[ $pk_name == ${att[$i]} ]]
												then
													pk_arr[1]=${att[$i]}            #getting pk attribute name 
													pk_arr[2]=$i                    #getting pk_columnNumber
												fi
											done
											echo $(IFS=:; echo "${att[*]}") >> $table_name                          #serializing with delimiter ":" attributes name in main table file
											echo $(IFS=:; echo "${const[*]}") > constraints_files/$table_name       #serializing with delimiter ":" constraints name in corresponiding constraints file
											echo $(IFS=:; echo "${att[*]}") >> constraints_files/$table_name        #serializing with delimiter ":" attributes name in corresponiding constraints file
											echo $(IFS=:; echo "${pk_arr[*]}") >> constraints_files/$table_name     #serializing with delimiter ":" pk name and column number in corresponiding constraints file
                						    echo "table created successfully !!"
                						    fi
                						    ClicktoClear
                	                		;;
                                    #List tables
                                    2) 
                                            if [ "$( ls -p | egrep -v /$ )" ]       #check if DB has no tables (neglect constraints_files directory)
                                            then
                                               	ls -p | egrep -v /$             #list files only
                                            else
                                                echo "There are no tables in this DataBase"
                                            fi
                                            ClicktoClear
                                            ;;
                                    #Drop table
                                    3) 
                                            read -p "Enter the name of the table: " table_name
                                            if [[ -e $table_name ]]                      #check if table exists
                                            then
                                                rm $table_name                  
											    rm constraints_files/$table_name         #delete table 
                                                echo "$table_name has been deleted"      #delete corresponding constraints file
                                            else
                                                echo "$table_name not found"
                                            fi
                                            ClicktoClear
                                            ;;
                                    #Insert into table
                                    4)     
                                            read -p "Enter the  Table name : " table_name
                                            if [[ -e $table_name ]]             #check if table exists
                                            then
												declare -a array
												declare -a pktmp
												declare -a  pk_arr
												unset pk_arr
												unset pk_tmp
                        					    unset array[@]
												unset const
												pk_tmp=(`grep "^PK" constraints_files/$table_name`)     #read pk line (PK:pk_name:pk_colNum) from constraints file
												IFS=':' read -ra pk_arr <<< ${pk_tmp[@]}                #cut the string with delimiter ":" and store it in pk_arr
                                            	IFS=':' read -ra all_fields < $table_name 	            #read attributes from table
                                            	IFS=':' read -ra const < constraints_files/$table_name 	#read constraints from constraints_files
                           	           			#reads data and check for constraints if data doesn't meet constraint won't insert
                                                for ((i=0;i<${#all_fields[@]};i++))
                                        	    do
													read -p "enter the  ${all_fields[i]} )" element
													if [[ ${const[$i]} == "int" ]]
													then
														if [[ $element =~ ^[0-9]+$ || $element == "" ]]
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
                            					        if [[ $element =~ ^[0-9]*\.?[0-9]+$ || $element == "" ]]
                            					        then
                            					                echo "float"
                            					        else
                            					                break 
														fi
													fi
                                                    #check for primary key insertion if wronge won't insert all the data
        	                					    if [[ $i -eq ${pk_arr[2]} ]]
													then
														if [[ $element == "" ]]
														then
															echo "didin't enter the primary key ${pk_arr[1]}"
															break
														else
															cut -d: -f"$((${pk_arr[2]}+1))" $table_name | grep -q "$element"
															if [[ $? -eq 0 ]]
															then
																echo "id( primary key ) already exists"
																break
															else
															array[$i]=$element
															fi
														fi
													else
														array[$i]=$element
													fi	
												done
                                                #insert data into table
												if [[ ${#array[@]} -eq ${#all_fields[@]} ]]
												then
                	        					    array_a=$(IFS=:; echo "${array[*]}")            #concatenate with delimiter ":" data in main table file
													echo "${array_a[@]}" >> $table_name             #insert to table 
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
                                                if [[ ! -e $table_name ]]           #chek if table exists
                                                then
                                                echo "table doesn't exist !!"
                                                else
											    	unset desired_fields
											    	set -f                              #this line disable "globing" which will allow the use to input the character "*" without converting it 
											    	echo "Enter the fields: (e.g (name1 name2 name3) )"
											    	read -a desired_fields              #read fields from user
											    	declare -a last_fields
											    	unset last_fields[@]                #the column numbers which will be passed to the awk
											    	unset all_fileds[@]
											    	IFS=':' read -ra all_fields < $table_name       #reads table attributes and pass it to all_fields array
											    	if [[ ${#desired_fields[@]} -eq 0 || "${desired_fields[0]}" == '*' ]]  #view the whole table if he entered nothing or "*"
											    	then
                                                        #pass all_fields to last_fields array(contain column numbers) which will be displayed
											    		for ((i=0;i<${#all_fields[@]};i++))
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
                    						                    	if [[ ${desired_fields[i]} == ${all_fields[j]}  ]]  #retrive desired fields column names from all fields even if the order is not equal to their order in the table
                    						                    	then
                    						                            last_fields=("${last_fields[@]}" "$(($j+1))")   #append to array last fields the column numbers
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
                                                    #desired fields is found in the table 
											    	if [[ $found == true ]]
											    	then
											    		declare -a condition_arr
											    		unset condition_arr
											    		condition=""
											    		echo "Enter the condition (e.g., salary > 5000):"
                    						            read -a condition_arr       #reading condition from user
											    		condition_flag=false        #check if condition valid (attribute name is valid)
											    		if [[ ${#condition_arr[@]} -ne 0  ]]    #no condition
                    						            then
											    			for ((j=0;j<${#all_fields[@]};j++))
                    		                           		do
                    		                                    if [[ ${condition_arr[0]} == ${all_fields[$j]} ]]   #checks if condiiton exists in table attributes
                    		                                    then
											    					condition=$(($j+1))
											    					condition_flag=true
											    					break
                    						                    fi
                    						                done
											    			if [[ $condition_flag == false ]]       #condition attribute name not found in table attributes
                    	                                    then
                    	                                            echo "${condition_arr[0]} not found in table"
                    	                                    fi
											    			if [[ ${condition_arr[1]} == "=" ]]     #make sure the condiiton is ready dor the awk 
											    			then
											    				condition_arr[1]="=="
											    			fi
											    		else
											    			echo "condition_arr is empty"
											    			condition=0

                    						            fi
											    		index=$(IFS=,; echo "${last_fields[*]}")                #serialization into one string to pass it to the awk then we will split it inside of the awk
                    		                        	desired_fields_s=$(IFS=,; echo "${desired_fields[*]}")  
                    		                        	f_count=${#desired_fields[@]}                           #used to structure the displayed table heading to be dynamic
											    		condition_f="\$$condition ${condition_arr[1]} ${condition_arr[2]}"  #make the condition on teh formula "ex: $5 > 5000" so teh awk can check with it 
											    		echo $condition_f
                                                        #best awk u will ever imagine dynamically shows table
											    		awk -F: -v fields="$index" -v headline="$desired_fields_s" -v total_length=15 -v fields_count="$f_count" 'BEGIN {printf "%s", "+";for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""; printf "|" ;split(headline, h, ",") ;for (i in h) {padding=total_length-length(h[i]);right=int(padding/2);left=padding-right; printf "%*s%s%*s|",left, "", h[i],right,"" };print""; printf "%s", "+"; for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""} { if ( NR != 1 && '"$condition_f"' ) { printf "%s", "|"; split(fields, f, ",") ; for (i in f) {padding=total_length-length($f[i]);right=int(padding/2);left=padding-right; printf "%*s%s%*s|",left, "", $f[i],right,"" } ; print"" } }  END{printf "%s","+" ;for(j=0;j<fields_count;j++){for(i=0;i<15;i++) {printf "%s","-"};printf"+"}; print""}' "$table_name" 
											    	fi
                                                fi
                    						    ClicktoClear
                    						    ;;
                                        6) 	#delete from table
												read -p "Enter the  Table name : " table_name		#reads the table name
                                                if [[ ! -e $table_name ]]		#checks if the table exists in the database
                                                then
                                                echo "table doesn't exist !!"
                                                else
                                                    condition=""		#resets the condition to an empty string
											    	declare condition_arr
                					    	        unset condition_arr
											    	echo "Enter the condition (e.g., salary >= 5000):"		#reads the condition from the user 
                					    	        read -a condition_arr
                					    	        condition_flag=false
											    	unset all_fileds[@]
                		                            IFS=':' read -ra all_fields < $table		#storing the name of the fields in the all_fields array
                		                            if [[ ${#condition_arr[@]} -ne 0  ]]		#checks if the user didn't enter any condition
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
                					                    if [[ ${condition_arr[1]} == "=" ]]
											    		then	
                					    	            condition_arr[1]="=="
											    		fi
                				                    else
                				                        echo "condition_arr is empty"
                				                    fi
											    	condition_f="\$$condition ${condition_arr[1]} ${condition_arr[2]}"		#passing the condition as a string to the awk
											    	awk -F: '{if (NR==1) print$0 ; if(NR!=1 && !('"$condition_f"')) print$0 }' $table_name  > temp && mv temp  $table_name 		#deleteing the data from the table
                					            fi
                                                ;;
                                        7) 	#update table 
						read -p "Enter the  Table name : " table_name		#reads the name of the table you want to update
                                                if [[ ! -e $table_name ]]		#checks if the table exists in the database
                                                then	
                                                echo "table doesn't exist !!"
                                                else
											    	unset desired_fields		
											    	unset value
											    	set -f 			#this line disable "globing" which will allow the use to input the character "*" without converting it 
											    	echo "Enter the field: (e.g (name1 name2 name3) )"	#reads the fields name you want to set 
											    	read -a desired_fields
											    	echo "Enter the values you want to set: (correspnding to the fields you chose) "	#reads an array of values corresponding to the desired fields
											    	read -a value
                                                    unset pk_arr
                                                    unset pk_tmp
                                                    pk_tmp=(`grep "^PK" constraints_files/$table_name`)		#gets the pk line from the constraint file
                                                    IFS=':' read -ra pk_arr <<< ${pk_tmp[@]}			#creating the pk_arr by removing the seprator ":"
											    	declare -a last_fields		
											    	unset last_fields[@] 		#the column numbers which will be passed to the awk
											    	unset all_fileds[@]
											    	IFS=':' read -ra all_fields < $table_name	#stors the names of the columns in the array all_fields
											    	if [[ ${#desired_fields[@]} -eq 0 || "${desired_fields[0]}" == '*' ]]	  #update the whole table if he entered nothing or "*"
											    	then
											    		for((i=0;i<${#all_fields[@]};i++))
											    		do
											    			last_fields=("${last_fields[@]}" "$(($i+1))") 
											    		done
											    		IFS=':' read -ra desired_fields < $table_name 		#retrive allfields into desired fields
											    		found=true
											    	else       # for specifing some of the columns
											    		for ((i=0;i<${#desired_fields[@]};i++))
                    				                   	do
                    				                       	found=false		#sets a variable found to false to check when he finds the corresponding column
                    				                       	for ((j=0;j<${#all_fields[@]};j++))
                    				                       	do
                    				                           	if [[ ${desired_fields[i]} == ${all_fields[j]} ]]
                    				                           	then
                    				                              	last_fields=("${last_fields[@]}" "$(($j+1))")
                    				                               	found=true
                    				                           	fi
                    				                       	done
                    				                       	if [[ $found == false ]]		#if the entered name wasn't found in the columns
                    				                       	then
                    				                          	echo "${desired_fields[i]} not found "
                    				                           	break
                    				                    	fi
                    				                   	done
											    	fi
											    	declare -a const
											    	unset const
                    						        IFS=':' read -ra const < constraints_files/$table_name 	#read constraints from file
											    	right_datatype=true
											    	
											    	
											    	
											    	for ((i=0;i<${#last_fields[@]};i++ ))
											    	do
											    		if [[ ${const[((${last_fields[$i]}-1))]} == "int" ]]		#checks if the field constraint is int to compare it to the input value
                    						           	then
                    						        	    if [[ ${value[i]} =~ ^[0-9]+$ ]]
                    						        	    then
                    						        	        echo "Number"
                    						        	    else
                    						        	        echo "wrong data type of the column"
                    						        	        right_datatype=false
                    						        	    fi
                    						           	elif  [[ ${const[((${last_fields[$i]}-1))]} == "char" ]]		#checks if the field constraint is character to compare it to the input value
                    						           	
                    						           	then
                    						               if [[ ${value[i]} =~ ^[0-9]*\.?[0-9]+$ ]]
                    						               then
                    						                   echo "wrong data type of the column"
                    						                   right_datatype=false
                    						               else
                    						                   echo "alpha"
                    						               fi
                    						           	elif [[ ${const[((${last_fields[$i]}-1))]} == "float" ]]		#checks if the field constraint is float to compare it to the input value
                    						           
                    						           	then
                    						               if [[ ${value[i]} =~ ^[0-9]*\.?[0-9]+$ ]]
                    						               then
                    						                   echo "float"
                    						               else
                    						                   echo "wrong data type of the column"
                    						                   right_datatype=false
                    						               fi
                    						           	fi
											    		if [[ ${last_fields[$i]} -eq $((${pk_arr[2]}+1)) ]]		#checks if you are setting a value to a primary key 
                    		                            then
                    		                               if [[ ${value[i]} == "" ]]		#if the value is NULL
                    		                               then
                    		                                    echo "didin't enter the primary key ${pk_arr[1]}"
							                                    right_datatype=false
                    		                                    break
                    		                               else
                    		                                   cut -d: -f"$((${pk_arr[2]}+1))" $table_name | grep -q "${value[i]}"		#makes sure the value you want to set is unique across the primary key column
                    		                                   if [[ $? -eq 0 ]]
                    		                                   then
                    		                                           echo " ${pk_arr[2]} already exists"
								                                        right_datatype=false
                    		                                           break
                    		                                   else
                    		                                   echo "coreect pk value"
                    		                                   fi
                    		                               fi
                    		                            else
                    		    	                        echo "not pk " 
                    		                            fi
											    	done
											    	set +f		 #re-enabling globing
											    	if [[ $found == true && $right_datatype == true ]]
											    	then
                    			                       	condition=""		#sets the condition variable to empty string
                    			                       	declare condition_arr
                    			                       	unset condition_arr
                    			                       	echo "Enter the condition (e.g., salary >= 5000):"		#reads the condition from the user
                    			                       	read -a condition_arr
                    			                       	condition_flag=false
                    			                       	unset all_fileds[@]
                    			                       	IFS=':' read -ra all_fields < $table_name			#stores the names of the table fields in the all_fields array
                    			                       	if [[ ${#condition_arr[@]} -ne 0  ]]		#if the user didn't enter a condition 
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
                    			                            
                    			                           	if [[ ${condition_arr[1]} == "=" ]]
                    			                           	then
                    			                                condition_arr[1]="=="
                    			                            fi
											    	    else
                    						                echo "condition_arr is empty"
                    						            fi
                    						            condition_f="\$$condition ${condition_arr[1]} ${condition_arr[2]}"		#assemble the condition to pass it to the awk 
											    		for((i=0;i<${#last_fields[@]};i++ ))
											    		do
											    		awk -F: '{if (NR==1) print$0 ; if(NR!=1 && '"$condition_f"') {OFS=FS; $'"${last_fields[$i]}"'="'"${value[$i]}"'" ;print$0 } else if(NR!=1) {print $0}}' $table_name  > temp && mv temp  $table_name 		#updating the table content
											    		done
											    	fi
                                                fi
                    						    ;;
                                        8) 
                                            #returns back to the database menu
                                            cd /home/$USER/bash-project		#changes the directory to the directory containing the databases
                                            back_flag=false			#sets the back flag to false to exit the inner loop
                                            clear
                                            ;;
                                        9)
                                            #exits the program
                                            cd /home/$USER/bash-project		#changes the directory to the directory containing the databases
                                            back_flag=false			#sets the back flag to false to exit the inner loop
                                            exit_flag=false			#sets the exit flag to false to exit the outer loop
                                            ;;
                                        *) echo " choose a number from 1 to 9 "		#makes sure the input is valid between 1 to 9
                                           ;;
                                esac
                        done
                    else	#if database is not found
                        echo "database not found"
                        ClicktoClear
                    fi
                    ;;
                4) 	#drop the database		
                        read -p "enter the name of the db you want to delete : " db_del		#reads the database name to delete
                        if [[ -e $db_del ]]	#checks if there is a database with this name
                        then
                            rm -rf /home/$USER/bash-project/$db_del
                            echo "$db_del has been deleted successfully !!"
                        else
                            echo "$db_del not found"
                        fi
                        ClicktoClear
                        ;;
                5) exit_flag=false				#exit program
                        ;;
                *) echo "choose a number from 1 to 5"		#makes sure the user input is from 1 to 5
                        ClicktoClear
                        ;;
        esac
done
~                                                                                                                    
