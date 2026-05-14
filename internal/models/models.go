package models

import "time"

type Film struct {
	ID            int        `json:"id" db:"id"`
	Name          string     `json:"name" db:"name"`
	Duration      int        `json:"duration" db:"duration"`
	YearOfIssue   int        `json:"year_of_issue" db:"year_of_issue"`
	Age           int        `json:"age" db:"age"`
	LinkImg       *string    `json:"link_img" db:"link_img"`
	LinkKinopoisk *string    `json:"link_kinopoisk" db:"link_kinopoisk"`
	LinkVideo     string     `json:"link_video" db:"link_video"`
	CreatedAt     time.Time  `json:"created_at" db:"created_at"`
	Country       Country    `json:"country"`
	Categories    []Category `json:"categories"`
	RatingAvg     float64    `json:"ratingAvg" db:"rating_avg"`
	ReviewCount   int        `json:"reviewCount" db:"review_count"`
}

type Country struct {
	ID        int    `json:"id" db:"id"`
	Name      string `json:"name" db:"name"`
	FilmCount int    `json:"filmCount,omitempty"`
}
