package main

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"os"
	"runtime"
	"strings"
)

var adjectives = []string{
	"admiring", "agile", "ancient", "bold", "brave",
	"bright", "calm", "clever", "cool", "cosmic",
	"daring", "eager", "elegant", "epic", "fearless",
	"fierce", "flying", "focused", "friendly", "gentle",
	"gifted", "golden", "graceful", "happy", "hopeful",
	"hungry", "jolly", "keen", "kind", "laughing",
	"lively", "lucky", "magical", "mighty", "modest",
	"musing", "nifty", "noble", "peaceful", "polite",
	"proud", "quick", "quiet", "rapid", "relaxed",
	"sharp", "shiny", "silent", "sleepy", "smart",
	"smooth", "snappy", "solid", "speedy", "stoic",
	"sunny", "sweet", "swift", "tender", "thirsty",
	"trusting", "upbeat", "vibrant", "vigilant", "warm",
	"wise", "witty", "wonderful", "zealous", "zen",
}

var nouns = []string{
	"albatross", "antelope", "badger", "bear", "beaver",
	"bird", "buffalo", "butterfly", "camel", "cat",
	"cheetah", "cobra", "condor", "crane", "deer",
	"dolphin", "dragon", "eagle", "elephant", "falcon",
	"ferret", "finch", "firefly", "fish", "flamingo",
	"fox", "frog", "gazelle", "giraffe", "goose",
	"gorilla", "hawk", "hedgehog", "heron", "horse",
	"hummingbird", "jaguar", "jellyfish", "kangaroo", "koala",
	"lemur", "leopard", "lion", "lizard", "lynx",
	"mammoth", "meerkat", "moose", "narwhal", "newt",
	"octopus", "orca", "otter", "owl", "panda",
	"panther", "parrot", "peacock", "pelican", "penguin",
	"phoenix", "pigeon", "puma", "rabbit", "raccoon",
	"raven", "salmon", "seahorse", "seal", "shark",
	"sparrow", "spider", "squid", "stork", "swan",
	"tiger", "toucan", "turtle", "unicorn", "viper",
	"walrus", "whale", "wolf", "wombat", "zebra",
}

func randomElement(slice []string) string {
	n, err := rand.Int(rand.Reader, big.NewInt(int64(len(slice))))
	if err != nil {
		return slice[0]
	}
	return slice[n.Int64()]
}

func generateName() string {
	return fmt.Sprintf("%s-%s", randomElement(adjectives), randomElement(nouns))
}

func getGoVersion() string {
	version := runtime.Version()
	version = strings.TrimPrefix(version, "go")
	parts := strings.Split(version, ".")
	if len(parts) >= 2 {
		return parts[0] + "." + parts[1]
	}
	return version
}

func main() {
	goVersion := getGoVersion()
	randomName := generateName()
	flavor := ""

	// Parse arguments
	for i := 1; i < len(os.Args); i++ {
		arg := os.Args[i]
		switch arg {
		case "--name":
			fmt.Println(randomName)
			return
		case "--version":
			fmt.Println(goVersion)
			return
		case "--alpine", "-A":
			flavor = "A"
		case "--debian", "-D":
			flavor = "D"
		case "--help", "-h":
			fmt.Println("Usage: taggen [OPTIONS]")
			fmt.Println()
			fmt.Println("Options:")
			fmt.Println("  (no args)    Print full tag: <go-version>-<random-name>")
			fmt.Println("  --alpine, -A Print tag with Alpine suffix: <go-version>A-<random-name>")
			fmt.Println("  --debian, -D Print tag with Debian suffix: <go-version>D-<random-name>")
			fmt.Println("  --name       Print only random name")
			fmt.Println("  --version    Print only Go version")
			fmt.Println()
			fmt.Println("Examples:")
			fmt.Println("  taggen           # 1.25-mighty-wolf")
			fmt.Println("  taggen -A        # 1.25A-mighty-wolf")
			fmt.Println("  taggen -D        # 1.25D-mighty-wolf")
			return
		}
	}

	tag := fmt.Sprintf("%s%s-%s", goVersion, flavor, randomName)
	fmt.Println(tag)
}
