package middleware

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/api/auth"
	"github.com/gin-gonic/gin"
	"github.com/golang/mock/gomock"
)

func TestSetAuthor_ShouldUpdateAuthor(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	expectedCode := http.StatusOK
	expectedAuthorValue := "test-author"

	noAuthorBody := map[string]interface{}{
		"test_key": "test_value",
	}

	noAuthorEncodedBody, _ := json.Marshal(noAuthorBody)
	req := httptest.NewRequest("POST", okURL, ioutil.NopCloser(bytes.NewBuffer(noAuthorEncodedBody)))

	router := gin.New()
	router.POST(
		okURL,
		// Mock UserKey in Context
		func(c *gin.Context) {
			c.Set(auth.UserKey, expectedAuthorValue)
		},
		SetAuthor(),
		func(c *gin.Context) {
			var body map[string]interface{}

			encodedBody := json.NewDecoder(c.Request.Body)
			err := encodedBody.Decode(&body)
			if err != nil {
				c.String(http.StatusInternalServerError, "%s", err)
			}

			c.String(expectedCode, "author %v", body["author"])
		},
	)

	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	if w.Code != expectedCode {
		t.Errorf("expected code: %v but got %v", expectedCode, w.Code)
	}

	expectedResponse := fmt.Sprintf("author %v", expectedAuthorValue)

	if w.Body.String() != expectedResponse {
		t.Errorf("expected response: \"%v\" but got \"%v\"", expectedResponse, w.Body.String())
	}
}

func TestSetAuthorToBulk_ShouldUpdateAuthorToAllItems(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	expectedCode := http.StatusOK
	author := "test-author"
	expectedAuthorValue := "test-author test-author test-author"

	noAuthorBody := []map[string]interface{}{
		{
			"test_key-1": "test_value-1",
		},
		{
			"test_key-2": "test_value-2",
		},
		{
			"test_key-3": "test_value-3",
		},
	}

	noAuthorEncodedBody, _ := json.Marshal(noAuthorBody)
	req := httptest.NewRequest("POST", okURL, ioutil.NopCloser(bytes.NewBuffer(noAuthorEncodedBody)))

	router := gin.New()
	router.POST(
		okURL,
		// Mock UserKey in Context
		func(c *gin.Context) {
			c.Set(auth.UserKey, author)
		},
		SetAuthorToBulk(),
		func(c *gin.Context) {
			var body []map[string]interface{}

			encodedBody := json.NewDecoder(c.Request.Body)
			err := encodedBody.Decode(&body)
			if err != nil {
				c.String(http.StatusInternalServerError, "%s", err)
			}

			var authorValues []string
			for _, item := range body {
				authorValues = append(authorValues, item["author"].(string))
			}

			c.String(expectedCode, "author %v", strings.Join(authorValues, " "))
		},
	)

	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	if w.Code != expectedCode {
		t.Errorf("expected code: %v but got %v", expectedCode, w.Code)
	}

	expectedResponse := fmt.Sprintf("author %v", expectedAuthorValue)

	if w.Body.String() != expectedResponse {
		t.Errorf("expected response: \"%v\" but got \"%v\"", expectedResponse, w.Body.String())
	}
}
