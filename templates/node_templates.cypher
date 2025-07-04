// =====================================================
// Business Model Canvas + JTBD Node Creation Templates
// Copy and customize these templates for your business model
// =====================================================

// =====================================================
// 1. BUSINESS MODEL NODE (Start here - create 1)
// =====================================================

CREATE (bm:BusinessModel {
    id: "bm_001",                                    // Change: Unique ID
    name: "[YOUR BUSINESS NAME]",                    // Change: Your business name
    description: "[BUSINESS DESCRIPTION]",           // Change: Brief description
    createdDate: date("2024-07-04"),                // Change: Today's date
    lastModified: date("2024-07-04")                // Change: Today's date
});

// =====================================================
// 2. VALUE PROPOSITION NODES (Create 2-4)
// =====================================================

CREATE (vp1:ValueProposition {
    id: "vp_001",                                    // Change: Sequential IDs
    title: "[VALUE PROP TITLE]",                     // Change: Your value prop title
    description: "[DETAILED DESCRIPTION]",           // Change: What you offer
    painReliever: "[CUSTOMER PAIN RELIEVED]",        // Change: What problem you solve
    gainCreator: "[CUSTOMER GAIN CREATED]"           // Change: What benefit you provide
});

// Template for additional value propositions:
CREATE (vp2:ValueProposition {
    id: "vp_002",
    title: "[SECOND VALUE PROP TITLE]",
    description: "[SECOND DESCRIPTION]",
    painReliever: "[SECOND PAIN RELIEVED]",
    gainCreator: "[SECOND GAIN CREATED]"
});

// =====================================================
// 3. CUSTOMER SEGMENT NODES (Create 2-4)
// =====================================================

CREATE (cs1:CustomerSegment {
    id: "cs_001",                                    // Change: Sequential IDs
    name: "[SEGMENT NAME]",                          // Change: Descriptive segment name
    description: "[SEGMENT DESCRIPTION]",            // Change: Who they are
    demographics: "[DEMOGRAPHIC INFO]",              // Change: Age, income, location, etc.
    psychographics: "[PSYCHOGRAPHIC INFO]",          // Change: Values, attitudes, lifestyle
    size: 10000                                      // Change: Estimated market size
});

// =====================================================
// 4. JOB EXECUTOR NODES (Create 1 per customer segment)
// =====================================================

CREATE (je1:JobExecutor {
    id: "je_001",                                    // Change: Sequential IDs
    name: "[JOB EXECUTOR NAME]",                     // Change: Who performs the job
    description: "[WHO THEY ARE]",                   // Change: Role/position description
    context: "[OPERATING CONTEXT]",                  // Change: Where/how they work
    constraints: "[THEIR CONSTRAINTS]",              // Change: What limits them
    capabilities: "[THEIR CAPABILITIES]",            // Change: What they can do
    motivations: "[THEIR MOTIVATIONS]"               // Change: What drives them
});

// =====================================================
// 5. JOB TO BE DONE NODES (Create 1 per customer segment)
// =====================================================

CREATE (job1:JobToBeDone {
    id: "job_001",                                   // Change: Sequential IDs
    jobStatement: "[JOB STATEMENT IN ODI FORMAT]",   // Change: Functional job description
    functionalAspect: "[FUNCTIONAL DIMENSION]",      // Change: What they're trying to do
    emotionalAspect: "[EMOTIONAL DIMENSION]",        // Change: How they want to feel
    socialAspect: "[SOCIAL DIMENSION]",              // Change: How they want to be perceived
    jobType: "core",                                 // Options: core, related, emotional, consumption
    frequency: "daily",                              // Options: daily, weekly, monthly, yearly
    importance: 8.5,                                 // Change: 1-10 importance rating
    satisfaction: 6.0,                               // Change: 1-10 current satisfaction
    opportunity: 8.2                                 // Change: Calculated opportunity score
});

// =====================================================
// 6. CHANNEL NODES (Create 3-5, include all 3 types)
// =====================================================

// ACQUISITION CHANNEL (How to attract customers)
CREATE (ch1:Channel {
    id: "ch_001",
    name: "[ACQUISITION CHANNEL NAME]",              // Change: e.g., "Digital Marketing"
    channelType: "acquisition",                      // Keep: acquisition
    medium: "digital",                               // Options: digital, physical, hybrid
    ownership: "owned",                              // Options: owned, partner, hybrid
    cost: 50000.0,                                  // Change: Monthly cost
    efficiency: 7.5,                                // Change: 1-10 efficiency rating
    reach: 100000                                   // Change: Potential customer reach
});

// DELIVERY CHANNEL (How to deliver value)
CREATE (ch2:Channel {
    id: "ch_002",
    name: "[DELIVERY CHANNEL NAME]",                 // Change: e.g., "Mobile App"
    channelType: "delivery",                         // Keep: delivery
    medium: "digital",                               // Options: digital, physical, hybrid
    ownership: "owned",                              // Options: owned, partner, hybrid
    cost: 25000.0,                                  // Change: Monthly cost
    efficiency: 9.0,                                // Change: 1-10 efficiency rating
    reach: 500000                                   // Change: Potential customer reach
});

// RETENTION CHANNEL (How to retain customers)
CREATE (ch3:Channel {
    id: "ch_003",
    name: "[RETENTION CHANNEL NAME]",                // Change: e.g., "Customer Success Program"
    channelType: "retention",                        // Keep: retention
    medium: "hybrid",                                // Options: digital, physical, hybrid
    ownership: "owned",                              // Options: owned, partner, hybrid
    cost: 30000.0,                                  // Change: Monthly cost
    efficiency: 8.5,                                // Change: 1-10 efficiency rating
    reach: 50000                                    // Change: Existing customer base
});

// =====================================================
// 7. CUSTOMER RELATIONSHIP NODES (Create 2-4)
// =====================================================

CREATE (cr1:CustomerRelationship {
    id: "cr_001",                                    // Change: Sequential IDs
    type: "personal",                                // Options: personal, automated, self-service, community
    purpose: "acquisition",                          // Options: acquisition, retention, boosting sales
    description: "[RELATIONSHIP DESCRIPTION]",       // Change: How you interact with customers
    cost: 15000.0                                   // Change: Monthly relationship cost
});

CREATE (cr2:CustomerRelationship {
    id: "cr_002",
    type: "automated",                               // Options: personal, automated, self-service, community
    purpose: "retention",                            // Options: acquisition, retention, boosting sales
    description: "[AUTOMATED RELATIONSHIP DESC]",    // Change: Automated interaction description
    cost: 8000.0                                    // Change: Monthly relationship cost
});

// =====================================================
// 8. REVENUE STREAM NODES (Create 2-4)
// =====================================================

CREATE (rs1:RevenueStream {
    id: "rs_001",                                    // Change: Sequential IDs
    name: "[REVENUE STREAM NAME]",                   // Change: e.g., "Monthly Subscriptions"
    type: "recurring",                               // Options: one-time, recurring
    pricingMechanism: "fixed",                       // Options: fixed, dynamic, market-based
    amount: 99.0,                                   // Change: Revenue amount per period
    frequency: "monthly"                            // Change: monthly, annual, per-transaction
});

CREATE (rs2:RevenueStream {
    id: "rs_002",
    name: "[SECOND REVENUE STREAM]",                 // Change: e.g., "Enterprise Licenses"
    type: "recurring",                               // Options: one-time, recurring
    pricingMechanism: "dynamic",                     // Options: fixed, dynamic, market-based
    amount: 10000.0,                                // Change: Revenue amount per period
    frequency: "annual"                             // Change: monthly, annual, per-transaction
});

// =====================================================
// 9. KEY RESOURCE NODES (Create 3-5)
// =====================================================

CREATE (kr1:KeyResource {
    id: "kr_001",                                    // Change: Sequential IDs
    name: "[RESOURCE NAME]",                         // Change: e.g., "Software Platform"
    type: "intellectual",                            // Options: physical, intellectual, human, financial
    description: "[RESOURCE DESCRIPTION]",           // Change: What this resource is
    ownership: "owned",                              // Options: owned, leased, partner
    cost: 500000.0                                  // Change: Resource cost (total or monthly)
});

CREATE (kr2:KeyResource {
    id: "kr_002",
    name: "[HUMAN RESOURCE NAME]",                   // Change: e.g., "Development Team"
    type: "human",                                   // Options: physical, intellectual, human, financial
    description: "[TEAM DESCRIPTION]",               // Change: Who they are and what they do
    ownership: "owned",                              // Options: owned, leased, partner
    cost: 200000.0                                  // Change: Monthly salary/cost
});

CREATE (kr3:KeyResource {
    id: "kr_003",
    name: "[INFRASTRUCTURE NAME]",                   // Change: e.g., "Cloud Infrastructure"
    type: "physical",                                // Options: physical, intellectual, human, financial
    description: "[INFRASTRUCTURE DESCRIPTION]",     // Change: Technical infrastructure
    ownership: "leased",                             // Options: owned, leased, partner
    cost: 25000.0                                   // Change: Monthly infrastructure cost
});

// =====================================================
// 10. KEY ACTIVITY NODES (Create 3-5)
// =====================================================

CREATE (ka1:KeyActivity {
    id: "ka_001",                                    // Change: Sequential IDs
    name: "[ACTIVITY NAME]",                         // Change: e.g., "Product Development"
    type: "production",                              // Options: production, problem-solving, platform/network
    description: "[ACTIVITY DESCRIPTION]",           // Change: What this activity involves
    priority: "high",                                // Options: high, medium, low
    cost: 150000.0                                  // Change: Monthly activity cost
});

CREATE (ka2:KeyActivity {
    id: "ka_002",
    name: "[MARKETING ACTIVITY]",                    // Change: e.g., "Customer Acquisition"
    type: "problem-solving",                         // Options: production, problem-solving, platform/network
    description: "[MARKETING DESCRIPTION]",          // Change: Marketing and sales activities
    priority: "high",                                // Options: high, medium, low
    cost: 75000.0                                   // Change: Monthly marketing cost
});

CREATE (ka3:KeyActivity {
    id: "ka_003",
    name: "[SUPPORT ACTIVITY]",                      // Change: e.g., "Customer Support"
    type: "problem-solving",                         // Options: production, problem-solving, platform/network
    description: "[SUPPORT DESCRIPTION]",            // Change: Customer support activities
    priority: "medium",                              // Options: high, medium, low
    cost: 40000.0                                   // Change: Monthly support cost
});

// =====================================================
// 11. KEY PARTNERSHIP NODES (Create 2-4)
// =====================================================

CREATE (kp1:KeyPartnership {
    id: "kp_001",                                    // Change: Sequential IDs
    partnerName: "[PARTNER NAME]",                   // Change: e.g., "AWS", "Microsoft"
    type: "supplier relationship",                   // Options: strategic alliance, joint venture, supplier relationship
    motivation: "[PARTNERSHIP MOTIVATION]",          // Change: Why this partnership exists
    description: "[PARTNERSHIP DESCRIPTION]",        // Change: What the partnership provides
    value: 100000.0                                 // Change: Annual value of partnership
});

CREATE (kp2:KeyPartnership {
    id: "kp_002",
    partnerName: "[STRATEGIC PARTNER]",              // Change: Strategic alliance partner
    type: "strategic alliance",                      // Options: strategic alliance, joint venture, supplier relationship
    motivation: "[STRATEGIC MOTIVATION]",            // Change: Strategic partnership reason
    description: "[STRATEGIC DESCRIPTION]",          // Change: Strategic partnership details
    value: 250000.0                                 // Change: Annual value of partnership
});

// =====================================================
// 12. COST STRUCTURE NODES (Create 3-5)
// =====================================================

CREATE (cost1:CostStructure {
    id: "cost_001",                                  // Change: Sequential IDs
    name: "[COST CATEGORY NAME]",                    // Change: e.g., "Personnel Costs"
    type: "fixed",                                   // Options: fixed, variable
    category: "operational",                         // Options: operational, marketing, infrastructure
    amount: 300000.0,                               // Change: Monthly cost amount
    frequency: "monthly"                            // Change: monthly, annual, quarterly
});

CREATE (cost2:CostStructure {
    id: "cost_002",
    name: "[INFRASTRUCTURE COSTS]",                  // Change: e.g., "Technology Infrastructure"
    type: "variable",                                // Options: fixed, variable
    category: "infrastructure",                      // Options: operational, marketing, infrastructure
    amount: 50000.0,                                // Change: Monthly cost amount
    frequency: "monthly"                            // Change: monthly, annual, quarterly
});

CREATE (cost3:CostStructure {
    id: "cost_003",
    name: "[MARKETING COSTS]",                       // Change: e.g., "Sales & Marketing"
    type: "variable",                                // Options: fixed, variable
    category: "marketing",                           // Options: operational, marketing, infrastructure
    amount: 100000.0,                               // Change: Monthly cost amount
    frequency: "monthly"                            // Change: monthly, annual, quarterly
});

// =====================================================
// USAGE INSTRUCTIONS:
// =====================================================

// 1. Copy each template section above
// 2. Replace all [PLACEHOLDER TEXT] with your specific values
// 3. Update IDs to be sequential (vp_001, vp_002, etc.)
// 4. Adjust costs, amounts, and ratings to match your business
// 5. Create multiple instances as needed for your business model
// 6. Run all CREATE statements in Neo4j after customization

// =====================================================
// ID NAMING CONVENTIONS:
// =====================================================

// BusinessModel:       bm_001, bm_002
// ValueProposition:    vp_001, vp_002, vp_003
// CustomerSegment:     cs_001, cs_002, cs_003
// JobExecutor:         je_001, je_002, je_003
// JobToBeDone:         job_001, job_002, job_003
// Channel:             ch_001, ch_002, ch_003
// CustomerRelationship: cr_001, cr_002, cr_003
// RevenueStream:       rs_001, rs_002, rs_003
// KeyResource:         kr_001, kr_002, kr_003
// KeyActivity:         ka_001, ka_002, ka_003
// KeyPartnership:      kp_001, kp_002, kp_003
// CostStructure:       cost_001, cost_002, cost_003

// =====================================================
// NEXT STEPS:
// =====================================================

// After creating all nodes:
// 1. Use Relationship-Templates.cypher to connect nodes
// 2. Run Validation-Queries.cypher to verify completeness
// 3. Ensure all 12 node types and 17+ relationship types are present
// 4. Check that you have all 3 channel types (acquisition, delivery, retention)

// =====================================================