#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed. Install it with 'pkg install jq'${NC}"
    exit 1
fi

# Check if termux-api is installed
if ! command -v termux-sms-send &> /dev/null; then
    echo -e "${RED}Error: termux-api is not installed. Install it with 'pkg install termux-api'${NC}"
    exit 1
fi

# Load contacts
load_contacts() {
    if [ ! -f "contacts.txt" ]; then
        echo "[]" > contacts.txt
    fi
    
    if ! jq empty contacts.txt &> /dev/null; then
        echo -e "${RED}Error: contacts.txt is not valid JSON${NC}"
        return 1
    fi
    
    contacts=$(cat contacts.txt)
    echo "$contacts"
}

# Clean phone number
clean_phone_number() {
    echo "$1" | sed -E 's/[^0-9+]//g'
}

# Send SMS
send_sms() {
    local number="$1"
    local message="$2"
    
    number=$(clean_phone_number "$number")
    
    echo -e "${GREEN}Sending SMS to $number...${NC}"
    termux-sms-send -n "$number" "$message"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}SMS sent successfully!${NC}"
    else
        echo -e "${RED}Failed to send SMS${NC}"
    fi
}

# Search and send SMS
search_and_send_sms() {
    while true; do
        clear
        echo -e "${BLUE}╔════════════════════════════╗${NC}"
        echo -e "${BLUE}║        SMS Manager        ║${NC}"
        echo -e "${BLUE}║   Creator: Pejman Morovat ║${NC}"
        echo -e "${BLUE}╚════════════════════════════╝${NC}"
        
        read -p "Enter name to search (or 'exit' to quit): " query
        
        if [ "$query" == "exit" ]; then
            echo -e "${GREEN}Goodbye!${NC}"
            sleep 1
            clear
            exit 0
        fi
        
        results=$(echo "$contacts" | jq -c --arg query "$query" '
            [.[] | select(.name | test($query; "i"))]
        ')
        count=$(echo "$results" | jq length)
        
        if [ "$count" -eq 0 ]; then
            echo -e "${RED}No contacts found.${NC}"
            read -p "Press Enter to continue..."
            continue
        fi
        
        echo -e "\n${GREEN}Search Results:${NC}"
        echo "$results" | jq -r '.[] | "\(.name): \(.number)"' | nl -w 2 -s ". " | while read line; do
            echo -e "${BLUE}${line}${NC}"
        done
        
        while true; do
            echo -e "${YELLOW}────────────────────────────${NC}"
            read -p "Enter contact number to send SMS (1, 2, etc.) or 0 to search again: " selection
            
            if [ "$selection" == "0" ]; then
                break
            fi
            
            if [[ "$selection" =~ ^[0-9]+$ ]]; then
                index=$((selection - 1))
                if [ "$index" -ge 0 ] && [ "$index" -lt "$count" ]; then
                    number=$(echo "$results" | jq -r ".[$index].number")
                    name=$(echo "$results" | jq -r ".[$index].name")
                    echo -e "${GREEN}Preparing SMS to $name ($number)...${NC}"
                    read -p "Enter your message: " message
                    send_sms "$number" "$message"
                    read -p "Press Enter to continue..."
                    break 2
                else
                    echo -e "${RED}Invalid selection number. Please try again.${NC}"
                fi
            else
                echo -e "${RED}Invalid input. Please enter a number.${NC}"
            fi
        done
    done
}

# Main program
clear
echo -e "${YELLOW}Loading SMS Manager...${NC}"
sleep 1
contacts=$(load_contacts) || exit 1
search_and_send_sms
