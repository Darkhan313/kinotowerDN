package models

type Category struct {
	ID             int       `json:"id" db:"id"`
	Name           string    `json:"name" db:"name"`
	ParentCategory *Category `json:"parentCategory" db:"-"`
	ParentID       *int      `json:"-" db:"parent_id"`
	FilmCount      int       `json:"filmCount" db:"film_count"`
}
