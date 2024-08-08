#!/bin/bash
while true; do
    active_postgres=$(systemctl is-active postgresql.service)

    ip_primary=$(/sbin/ip address show dev ${HA_NIC} | grep ${VIP_MAIN} | wc -l)
    ip_standby=$(/sbin/ip address show dev ${HA_NIC} | grep ${VIP_BACKUP} | wc -l)
    
    if [ "$active_postgres" = "active" ]; then
        active_node_1=$(psql -h localhost -At  -d repmgr -U repmgr -c 'select active from nodes where node_id=1;')
        active_node_2=$(psql -h localhost -At  -d repmgr -U repmgr -c 'select active from nodes where node_id=2;')

        {% if ha_role == "main" %}

        database_role=$(psql -h localhost -At  -d repmgr -U repmgr -c 'select type from nodes where node_id=1;')

        if [ "$active_node_1" = "t" ]; then
            if [ "$database_role" = "primary" ]; then
                if [ $ip_primary -eq 0 ]; then
                    ip addr add ${VIP_MAIN}/24 dev ${HA_NIC}
                    ip link set dev ${HA_NIC} up
                fi

                if [ "$active_node_2" = "f" ]; then
                    ip addr add ${VIP_BACKUP}/24 dev ${HA_NIC}
                    ip link set dev ${HA_NIC} up
                else
                    if [ $ip_standby -eq 1 ]; then
                        ip addr del ${VIP_BACKUP}/24 dev ${HA_NIC}
                    fi
                fi
            else
                if [ $ip_standby -eq 0 ]; then
                    ip addr add ${VIP_BACKUP}/24 dev ${HA_NIC}
                    ip link set dev ${HA_NIC} up
                fi
                if [ $ip_primary -eq 1 ]; then
                    ip addr del ${VIP_MAIN}/24 dev ${HA_NIC}
                fi
            fi
        else
            if [ $ip_primary -eq 1 ]; then
                ip addr del ${VIP_MAIN}/24 dev ${HA_NIC}
            fi
            if [ $ip_standby -eq 1 ]; then
                ip addr del ${VIP_BACKUP}/24 dev ${HA_NIC}
            fi
        fi

        {% else %}

        database_role=$(psql -h localhost -At  -d repmgr -U repmgr -c 'select type from nodes where node_id=2;')

        if [ "$active_node_2" = "t" ]; then
            if [ "$database_role" = "primary" ]; then
                if [ $ip_primary -eq 0 ]; then
                    ip addr add ${VIP_MAIN}/24 dev ${HA_NIC}
                    ip link set dev ${HA_NIC} up
                fi

                if [ "$active_node_1" = "f" ]; then
                    ip addr add ${VIP_BACKUP}/24 dev ${HA_NIC}
                    ip link set dev ${HA_NIC} up
                else
                    if [ $ip_standby -eq 1 ]; then
                        ip addr del ${VIP_BACKUP}/24 dev ${HA_NIC}
                    fi
                fi
            else
                if [ $ip_standby -eq 0 ]; then
                    ip addr add ${VIP_BACKUP}/24 dev ${HA_NIC}
                    ip link set dev ${HA_NIC} up
                fi
                if [ $ip_primary -eq 1 ]; then
                    ip addr del ${VIP_MAIN}/24 dev ${HA_NIC}
                fi
            fi
        else
            if [ $ip_primary -eq 1 ]; then
                ip addr del ${VIP_MAIN}/24 dev ${HA_NIC}
            fi
            if [ $ip_standby -eq 1 ]; then
                ip addr del ${VIP_BACKUP}/24 dev ${HA_NIC}
            fi
        fi

        {% endif %}

    else
        echo "Postgres is not active !!!"

        if [ $ip_primary -eq 1 ]; then
            ip addr del ${VIP_MAIN}/24 dev ${HA_NIC}
        fi
        if [ $ip_standby -eq 1 ]; then
            ip addr del ${VIP_BACKUP}/24 dev ${HA_NIC}
        fi
    fi

    sleep 5
done
