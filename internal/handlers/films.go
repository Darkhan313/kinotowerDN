package handlers

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/Darkhan313/kinotowerDN/internal/repository"
)

type FilmHandler struct {
	repo *repository.FilmRepo
}

func NewFilmHandler(repo *repository.FilmRepo) *FilmHandler {
	return &FilmHandler{repo: repo}
}

func (h *FilmHandler) GetFilms(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()

	// Парсим параметры из URL (с дефолтными значениями из ТЗ)
	page, _ := strconv.Atoi(q.Get("page"))
	if page < 1 {
		page = 1
	}

	size, _ := strconv.Atoi(q.Get("size"))
	if size < 1 {
		size = 10
	}

	sortBy := q.Get("sortBy")
	if sortBy == "" {
		sortBy = "name"
	}

	sortDir := q.Get("sortDir")
	if sortDir == "" || (sortDir != "asc" && sortDir != "desc") {
		sortDir = "asc"
	}

	categoryID, _ := strconv.Atoi(q.Get("category"))
	countryID, _ := strconv.Atoi(q.Get("country"))
	search := q.Get("search")

	// Получаем данные из репозитория
	films, total, err := h.repo.GetAll(page, size, sortBy, sortDir, categoryID, countryID, search)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Формируем JSON ответ точно по ТЗ (стр. 5)
	response := map[string]interface{}{
		"page":  page,
		"size":  len(films),
		"total": total,
		"films": films,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}
