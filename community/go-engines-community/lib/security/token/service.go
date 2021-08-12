package token

import (
	"fmt"
	"time"

	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/config"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/utils"
	"github.com/golang-jwt/jwt"
)

type Service interface {
	GenerateToken(id string) (string, time.Time, error)
	ValidateToken(token string) (id string, err error)
}

func NewJwtService(
	secretKey []byte,
	issuer string,
	apiConfigProvider config.ApiConfigProvider,
) Service {
	return &jwtService{
		secretKey:         secretKey,
		issuer:            issuer,
		apiConfigProvider: apiConfigProvider,
	}
}

type jwtService struct {
	secretKey         []byte
	issuer            string
	apiConfigProvider config.ApiConfigProvider
}

type tokenClaims struct {
	ID string `json:"_id"`
	jwt.StandardClaims
}

func (s *jwtService) GenerateToken(id string) (string, time.Time, error) {
	cfg := s.apiConfigProvider.Get()
	now := time.Now()
	expiresAt := now.Add(cfg.TokenExpiration)
	claims := tokenClaims{
		ID: id,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expiresAt.Unix(),
			Id:        utils.NewID(),
			IssuedAt:  now.Unix(),
			Issuer:    s.issuer,
		},
	}
	token := jwt.NewWithClaims(cfg.TokenSigningMethod, claims)

	t, err := token.SignedString(s.secretKey)
	if err != nil {
		return "", time.Time{}, fmt.Errorf("cannot generate token: %w", err)
	}

	return t, expiresAt, nil
}

func (s *jwtService) ValidateToken(tokenString string) (string, error) {
	token, err := jwt.ParseWithClaims(tokenString, &tokenClaims{}, func(token *jwt.Token) (interface{}, error) {
		cfg := s.apiConfigProvider.Get()

		if token.Method.Alg() != cfg.TokenSigningMethod.Alg() {
			return nil, fmt.Errorf("unexpected signing method: %q, expected %q", token.Method.Alg(), cfg.TokenSigningMethod.Alg())
		}

		return s.secretKey, nil
	})
	if err != nil {
		return "", fmt.Errorf("cannot parse token : %w", err)
	}

	if !token.Valid {
		return "", fmt.Errorf("token is invalid")
	}

	if claims, ok := token.Claims.(*tokenClaims); ok {
		return claims.ID, nil
	}

	return "", fmt.Errorf("token claims are invalid")
}
