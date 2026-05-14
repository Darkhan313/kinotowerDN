package main

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/Darkhan313/kinotowerDN/internal/handlers" // Добавили импорт хендлеров
	"github.com/Darkhan313/kinotowerDN/internal/repository"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func main() {
	// 1. Подключение к БД
	db, err := repository.NewPostgresDB(repository.Config{
		Host: "localhost", Port: "5432", Username: "postgres", Password: "postgres", DBName: "kinotower", SSLMode: "disable",
	})
	if err != nil {
		log.Fatal("DB connect error:", err)
	}
	defer db.Close()

	// 2. Инициализация Репозиториев
	categoryRepo := repository.NewCategoryRepo(db)
	filmRepo := repository.NewFilmRepo(db)
	// Добавь здесь репозитории для стран и пользователей, когда напишешь их

	// 3. Инициализация Хендлеров (Обработчиков)
	filmHandler := handlers.NewFilmHandler(filmRepo)

	r := chi.NewRouter()

	// Полезные дополнения: логирование запросов в консоль
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	// 4. Группировка эндпоинтов API v1
	r.Route("/api/v1", func(r chi.Router) {

		// --- ФИЛЬМЫ ---
		// Эндпоинт из ТЗ стр. 4 (Список фильмов с фильтрами)
		r.Get("/films", filmHandler.GetFilms)

		// Эндпоинт из ТЗ стр. 6 (Один фильм по ID)
		// r.Get("/films/{id}", filmHandler.GetFilmByID) // Реализуй этот метод в хендлере позже

		// --- КАТЕГОРИИ ---
		r.Get("/categories", func(w http.ResponseWriter, r *http.Request) {
			categories, err := categoryRepo.GetAll()
			if err != nil {
				http.Error(w, "Database error", http.StatusInternalServerError)
				return
			}
			response := map[string]interface{}{"categories": categories}
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(response)
		})

		// --- СТРАНЫ (стр. 8 ТЗ) ---
		r.Get("/countries", func(w http.ResponseWriter, r *http.Request) {
			// Здесь будет вызов countryRepo.GetAll()
			w.Write([]byte(`{"countries": []}`))
		})
	})

	log.Println("Server started on :8080")
	if err := http.ListenAndServe(":8080", r); err != nil {
		log.Fatal("Server error:", err)
	}
}
