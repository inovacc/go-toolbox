#!/bin/bash
# taggen.sh - Generate Docker image tags with Go version and random name
# Usage: ./taggen.sh [-A|-D|--name|--version]

ADJECTIVES=(
    admiring agile ancient bold brave bright calm clever cool cosmic
    daring eager elegant epic fearless fierce flying focused friendly gentle
    gifted golden graceful happy hopeful hungry jolly keen kind laughing
    lively lucky magical mighty modest musing nifty noble peaceful polite
    proud quick quiet rapid relaxed sharp shiny silent sleepy smart
    smooth snappy solid speedy stoic sunny sweet swift tender thirsty
    trusting upbeat vibrant vigilant warm wise witty wonderful zealous zen
)

NOUNS=(
    albatross antelope badger bear beaver bird buffalo butterfly camel cat
    cheetah cobra condor crane deer dolphin dragon eagle elephant falcon
    ferret finch firefly fish flamingo fox frog gazelle giraffe goose
    gorilla hawk hedgehog heron horse hummingbird jaguar jellyfish kangaroo koala
    lemur leopard lion lizard lynx mammoth meerkat moose narwhal newt
    octopus orca otter owl panda panther parrot peacock pelican penguin
    phoenix pigeon puma rabbit raccoon raven salmon seahorse seal shark
    sparrow spider squid stork swan tiger toucan turtle unicorn viper
    walrus whale wolf wombat zebra
)

# Get random element from array
random_element() {
    local arr=("$@")
    echo "${arr[$RANDOM % ${#arr[@]}]}"
}

# Generate random name
generate_name() {
    local adj=$(random_element "${ADJECTIVES[@]}")
    local noun=$(random_element "${NOUNS[@]}")
    echo "${adj}-${noun}"
}

# Get Go version from argument or default
get_go_version() {
    if [[ -n "$GO_VERSION" ]]; then
        echo "$GO_VERSION"
    else
        echo "1.25"
    fi
}

# Main
FLAVOR=""
GO_VER=$(get_go_version)
RANDOM_NAME=$(generate_name)

for arg in "$@"; do
    case $arg in
        -A|--alpine)
            FLAVOR="A"
            ;;
        -D|--debian)
            FLAVOR="D"
            ;;
        --name)
            echo "$RANDOM_NAME"
            exit 0
            ;;
        --version)
            echo "$GO_VER"
            exit 0
            ;;
        -h|--help)
            echo "Usage: taggen.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  (no args)    Print full tag: <go-version>-<random-name>"
            echo "  -A, --alpine Print tag with Alpine suffix: <go-version>A-<random-name>"
            echo "  -D, --debian Print tag with Debian suffix: <go-version>D-<random-name>"
            echo "  --name       Print only random name"
            echo "  --version    Print only Go version"
            echo ""
            echo "Environment:"
            echo "  GO_VERSION   Override Go version (default: 1.25)"
            echo ""
            echo "Examples:"
            echo "  taggen.sh           # 1.25-mighty-wolf"
            echo "  taggen.sh -A        # 1.25A-mighty-wolf"
            echo "  taggen.sh -D        # 1.25D-mighty-wolf"
            exit 0
            ;;
    esac
done

echo "${GO_VER}${FLAVOR}-${RANDOM_NAME}"
