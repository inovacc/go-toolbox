package cmd

import (
	"github.com/inovacc/mjolnir/examples/go/internal/api"
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "api",
	Short: "Example Go web API using Mjolnir",
	Long:  "A minimal Go web API demonstrating how to use Mjolnir for building production-grade Docker images.",
	RunE:  api.Server,
}

func Execute() {
	cobra.CheckErr(rootCmd.Execute())
}

func init() {
	rootCmd.CompletionOptions.DisableDefaultCmd = true
}
