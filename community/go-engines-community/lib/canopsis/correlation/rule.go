package correlation

import (
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/pattern"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/savedpattern"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/types"
)

const (
	// Component-resource matching
	RuleTypeRelation  = "relation"
	RuleTypeTimeBased = "timebased"
	// RuleTypeAttribute for Attribute matching
	RuleTypeAttribute = "attribute"
	// RuleTypeComplex for complex rules
	RuleTypeComplex = "complex"

	RuleValueGroup = "valuegroup"

	RuleManualGroup = "manualgroup"

	RuleCorel = "corel"
)

type Rule struct {
	// ID is a unique id for the rule.
	ID string `bson:"_id" json:"_id"`

	Type string `bson:"type" json:"type"`

	Config RuleConfig `bson:"config" json:"config"`

	// Name was added to identify manual grouping
	Name string `bson:"name" json:"name"`

	Author string `bson:"author" json:"author"`

	AutoResolve bool `bson:"auto_resolve" json:"auto_resolve"`

	OutputTemplate string `bson:"output_template" json:"output_template"`

	savedpattern.EntityPatternFields `bson:",inline"`
	savedpattern.AlarmPatternFields  `bson:",inline"`
	TotalEntityPatternFields

	Created *types.CpsTime `bson:"created,omitempty" json:"created,omitempty" swaggertype:"integer"`
	Updated *types.CpsTime `bson:"updated,omitempty" json:"updated,omitempty" swaggertype:"integer"`
}

type TotalEntityPatternFields struct {
	TotalEntityPattern pattern.Entity `bson:"total_entity_pattern" json:"total_entity_pattern,omitempty"`

	CorporateTotalEntityPattern      string `bson:"corporate_total_entity_pattern" json:"corporate_total_entity_pattern,omitempty"`
	CorporateTotalEntityPatternTitle string `bson:"corporate_total_entity_pattern_title" json:"corporate_total_entity_pattern_title,omitempty"`
}
