#!/bin/bash
while [ 1 ];
do
        active_postgres=$(systemctl is-active postgresql-11.service)

        ip_primary=$(/sbin/ip address show dev ${HA_NIC} | grep ${VIP_MAIN} | wc -l)
        ip_standby=$(/sbin/ip address show dev ${HA_NIC} | grep ${VIP_BACKUP} | wc -l)
        
        if [ "$active_postgres" = "active" ];
        then
                active_node_1=$(psql -At -d repmgr -U repmgr -c 'select active from nodes where node_id=1;')
                active_node_2=$(psql -At -d repmgr -U repmgr -c 'select active from nodes where node_id=2;')

		{% if ha_rol == "main" %}

                database_role=$(psql -At -d repmgr -U repmgr -c 'select type from nodes where node_id=1;')

                if [ "$active_node_1" = "t" ];
                then
                        if [ "$database_role" = "primary" ];
                        then
                                if [ $ip_primary -eq 0 ];
                                then
                                        ifup ${HA_NIC}:0
                                fi

                                if [ "$active_node_2" = "f" ];
                                then
                                        ifup ${HA_NIC}:1
                                else
                                        if [ $ip_standby -eq 1 ];
                                        then
                                                ifdown ${HA_NIC}:1
                                        fi
                                fi
                        else
                                if [ $ip_standby -eq 0 ];
                                then
                                        ifup ${HA_NIC}:1
                                fi
                                if [ $ip_primary -eq 1 ];
                                then
                                        ifdown ${HA_NIC}:0
                                fi
                        fi
                else
                        if [ $ip_primary -eq 1 ];
                        then
                                ifdown ${HA_NIC}:0
                        fi
                        if [ $ip_standby -eq 1 ];
                        then
                                ifdown ${HA_NIC}:1
                        fi
                fi


		{% else %}

		database_role=$(psql -At -d repmgr -U repmgr -c 'select type from nodes where node_id=2;')

                if [ "$active_node_2" = "t" ];
                then
                        if [ "$database_role" = "primary" ];
                        then
                                if [ $ip_primary -eq 0 ];
                                then
                                        ifup ${HA_NIC}:0
                                fi

                                if [ "$active_node_1" = "f" ];
                                then
                                        ifup ${HA_NIC}:1
                                else
                                        if [ $ip_standby -eq 1 ];
                                        then
                                                ifdown ${HA_NIC}:1
                                        fi
                                fi
                        else
                                if [ $ip_standby -eq 0 ];
                                then
                                        ifup ${HA_NIC}:1
                                fi
                                if [ $ip_primary -eq 1 ];
                                then
                                        ifdown ${HA_NIC}:0
                                fi
                        fi
                else
                        if [ $ip_primary -eq 1 ];
                        then
                                ifdown ${HA_NIC}:0
                        fi
                        if [ $ip_standby -eq 1 ];
                        then
                                ifdown ${HA_NIC}:1
                        fi
                fi



		{% endif %}


        else
                if [ $ip_primary -eq 1 ];
                then
                        ifdown ${HA_NIC}:0
                fi
                if [ $ip_standby -eq 1 ];
                then
                        ifdown ${HA_NIC}:1
                fi
        fi

   sleep 5
done
