package repository

import (
	"github.com/Darkhan313/kinotowerDN/internal/models"
	"github.com/jmoiron/sqlx"
)

type CategoryRepo struct {
	db *sqlx.DB
}

func NewCategoryRepo(db *sqlx.DB) *CategoryRepo {
	return &CategoryRepo{db: db}
}

func (r *CategoryRepo) GetAll() ([]models.Category, error) {
	var categories []models.Category

	// SQL запрос: берем категории и считаем количество связей в categories_films
	query := `
		SELECT c.id, c.name, c.parent_id, COUNT(cf.film_id) as film_count
		FROM categories c
		LEFT JOIN categories_films cf ON c.id = cf.category_id
		GROUP BY c.id, c.name, c.parent_id
	`

	err := r.db.Select(&categories, query)
	return categories, err
}
