package fixtures

import (
	"errors"
	"strings"
	"time"

	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/security/password"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/utils"
	"github.com/brianvoe/gofakeit/v6"
	"github.com/golang-jwt/jwt/v4"
)

type Faker struct {
	*gofakeit.Faker
	passwordEncoder password.Encoder

	usedNames map[string]struct{}
}

func NewFaker(passwordEncoder password.Encoder) *Faker {
	return &Faker{
		Faker:           gofakeit.New(0),
		passwordEncoder: passwordEncoder,
		usedNames:       make(map[string]struct{}),
	}
}

func (*Faker) NowUnix() interface{} {
	return time.Now().Unix()
}

func (f *Faker) DateUnix() interface{} {
	return f.Number(1, int(time.Now().Unix()))
}

func (f *Faker) Password(password string) string {
	return string(f.passwordEncoder.EncodePassword([]byte(password)))
}

func (f *Faker) UniqueName() (string, error) {
	for nameLen := 5; nameLen < 11; nameLen++ {
		for try := 0; try < 3; try++ {
			v := f.Generate(strings.Repeat("?", nameLen))
			if _, ok := f.usedNames[v]; !ok {
				f.usedNames[v] = struct{}{}
				return v, nil
			}
		}
	}

	return "", errors.New("cannot generate unique name")
}

func (f *Faker) ResetUniqueName() {
	f.usedNames = make(map[string]struct{})
}

func (f *Faker) JWT() (string, error) {
	registeredClaims := jwt.RegisteredClaims{
		ID:       utils.NewID(),
		IssuedAt: jwt.NewNumericDate(time.Now()),
		Issuer:   canopsis.AppName,
	}

	return jwt.NewWithClaims(jwt.SigningMethodHS256, registeredClaims).SignedString([]byte(""))
}
