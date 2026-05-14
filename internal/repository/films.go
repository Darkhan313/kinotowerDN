package repository

import (
	"fmt"
	"strings"

	"github.com/Darkhan313/kinotowerDN/internal/models"
	"github.com/jmoiron/sqlx"
)

type FilmRepo struct {
	db *sqlx.DB
}

func NewFilmRepo(db *sqlx.DB) *FilmRepo {
	return &FilmRepo{db: db}
}

// GetAll возвращает список фильмов, общее количество и ошибку
func (r *FilmRepo) GetAll(page, size int, sortBy, sortDir string, categoryID, countryID int, search string) ([]models.Film, int, error) {
	var films []models.Film
	var total int

	// 1. Формируем условия фильтрации (WHERE)
	var whereClauses []string
	var args []interface{}
	argID := 1

	whereClauses = append(whereClauses, "f.deleted_at IS NULL")

	if categoryID > 0 {
		whereClauses = append(whereClauses, fmt.Sprintf("f.id IN (SELECT film_id FROM categories_films WHERE category_id = $%d)", argID))
		args = append(args, categoryID)
		argID++
	}
	if countryID > 0 {
		whereClauses = append(whereClauses, fmt.Sprintf("f.country_id = $%d", argID))
		args = append(args, countryID)
		argID++
	}
	if search != "" {
		whereClauses = append(whereClauses, fmt.Sprintf("f.name ILIKE $%d", argID))
		args = append(args, "%"+search+"%")
		argID++
	}

	whereString := strings.Join(whereClauses, " AND ")

	// 2. Сначала получаем общее количество (total)
	countQuery := fmt.Sprintf("SELECT COUNT(*) FROM films f WHERE %s", whereString)
	err := r.db.Get(&total, countQuery, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("count error: %w", err)
	}

	// 3. Определяем поле для сортировки
	allowedSort := map[string]string{
		"name":   "f.name",
		"year":   "f.year_of_issue",
		"rating": "rating_avg",
	}
	sortField := allowedSort[sortBy]
	if sortField == "" {
		sortField = "f.name"
	}

	// 4. Получаем сами данные фильмов
	dataQuery := fmt.Sprintf(`
		SELECT f.id, f.name, f.duration, f.year_of_issue, f.age, f.link_img, f.link_kinopoisk, f.link_video, f.created_at,
		       COALESCE((SELECT AVG(ball) FROM ratings WHERE film_id = f.id), 0) as rating_avg,
		       (SELECT COUNT(*) FROM reviews WHERE film_id = f.id AND is_approved = true) as review_count
		FROM films f
		WHERE %s
		ORDER BY %s %s 
		LIMIT %d OFFSET %d`,
		whereString, sortField, sortDir, size, (page-1)*size)

	err = r.db.Select(&films, dataQuery, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("select error: %w", err)
	}
	err = r.db.Select(&films, dataQuery, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("select error: %w", err)
	}

	// ВОТ ЭТО ДОБАВЬ:
	if films == nil {
		films = []models.Film{}
	}

	return films, total, nil
}
