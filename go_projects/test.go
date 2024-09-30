package main

import (
	"fmt"
	"os"
	"path/filepath"
	"time"
)

func main() {

	directory := "~/Downloads/uploads" // file path

	// Get the current time and calculate the delete time (3 months ago)
	now := time.Now()
	old := now.AddDate(0, -3, 0)

	err := filepath.Walk(directory, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Check if the file name matches  ISO 8601 format
		if !info.IsDir() && filepath.Ext(info.Name()) == ".csv" {

			// Parse the date from the file name
			var fileDate time.Time
			var year, month, day int
			_, err := fmt.Sscanf(info.Name(), "abc-%d-%d-%d.csv", &year, &month, &day)
			if err != nil {
				return nil // Skip files that don't match the naming convention
			}

			// Check if the file date is older than the delete date
			if fileDate.Before(old) {
				fmt.Printf("Removing: %s\n", path)
				err := os.Remove(path)
				if err != nil {
					fmt.Printf("Error removing file: %s\n", err)
				}
			}
		}
		return nil
	})

	if err != nil {
		fmt.Printf("Error walking the directory: %s\n", err)
	}
}
