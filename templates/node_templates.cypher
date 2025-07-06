// =====================================================
// Business Model Canvas + JTBD Node Creation Templates
// WITH SEMANTIC ENHANCEMENT FROM BUSINESS LITERATURE
// Copy and customize these templates for your business model
// =====================================================

// =====================================================
// SEMANTIC ENHANCEMENT OVERVIEW
// =====================================================
// Each node now contains research-based semantic descriptions from:
// - Alexander Osterwalder & Yves Pigneur (Business Model Canvas)
// - Clayton Christensen (Jobs-to-be-Done Theory)  
// - Anthony Ulwick (Outcome-Driven Innovation)
// - Harvard Business Review research
// - Strategic management academic literature

// =====================================================
// 1. BUSINESS MODEL NODE (Start here - create 1)
// =====================================================

CREATE (bm:BusinessModel {
    id: "bm_001",                                    // Change: Unique ID
    name: "[YOUR BUSINESS NAME]",                    // Change: Your business name
    description: "[BUSINESS DESCRIPTION]",           // Change: Brief description
    createdDate: date("2024-07-04"),                // Change: Today's date
    lastModified: date("2024-07-04"),               // Change: Today's date
    
    // Semantic Enhancement Properties - Research-Based Definitions
    semanticDescription: "A strategic management template used for developing new business models and documenting existing ones. It offers a visual chart with elements describing a firm's or product's value proposition, infrastructure, customers, and finances, assisting businesses to align their activities by illustrating potential trade-offs.",
    theoreticalFoundation: "Based on Alexander Osterwalder and Yves Pigneur's Business Model Canvas framework, co-created with 470 practitioners from 45 countries. The canvas consists of nine building blocks that describe value proposition, infrastructure, customers, and finances.",
    purpose: "To help companies move beyond product-centric thinking towards business model thinking, enabling structured conversations around new businesses or existing ones for strategic management and innovation."
});

// =====================================================
// 2. VALUE PROPOSITION NODES (Create 2-4)
// =====================================================

CREATE (vp1:ValueProposition {
    id: "vp_001",                                    // Change: Sequential IDs
    title: "[VALUE PROP TITLE]",                     // Change: Your value prop title
    description: "[DETAILED DESCRIPTION]",           // Change: What you offer
    
    // Semantic Enhancement Properties - Osterwalder Research
    semanticDescription: "The collection of products and services a business offers to meet the needs of its customers. According to Osterwalder, a company's value proposition is what distinguishes it from its competitors. It provides value through various elements such as newness, performance, customization, getting the job done, design, brand/status, price, cost reduction, risk reduction, accessibility, and convenience/usability.",
    theoreticalFoundation: "Central element of Osterwalder's Business Model Canvas, representing the unique combination of products and services that create value for specific customer segments. The value proposition is at the center of the canvas, connecting customer-facing and infrastructure elements.",
    valueElements: "Provides value through: newness, performance improvement, customization, job completion, superior design, brand/status, competitive pricing, cost reduction, risk mitigation, improved accessibility, enhanced convenience and usability."
});

// Template for additional value propositions:
CREATE (vp2:ValueProposition {
    id: "vp_002",
    title: "[SECOND VALUE PROP TITLE]",
    description: "[SECOND DESCRIPTION]",
    semanticDescription: "The collection of products and services a business offers to meet the needs of its customers. According to Osterwalder, a company's value proposition is what distinguishes it from its competitors.",
    theoreticalFoundation: "Central element of Osterwalder's Business Model Canvas, representing the unique combination of products and services that create value for specific customer segments.",
    valueElements: "Provides value through: newness, performance improvement, customization, job completion, superior design, brand/status, competitive pricing, cost reduction, risk mitigation, improved accessibility, enhanced convenience and usability."
});

// =====================================================
// 3. CUSTOMER SEGMENT NODES (Create 2-4)
// =====================================================

CREATE (cs1:CustomerSegment {
    id: "cs_001",                                    // Change: Sequential IDs
    name: "[SEGMENT NAME]",                          // Change: Descriptive segment name
    description: "[SEGMENT DESCRIPTION]",            // Change: Who they are
    
    // Semantic Enhancement Properties - Business Model Canvas Research
    semanticDescription: "The different groups of people or organizations an enterprise aims to reach and serve. To build an effective business model, a company must identify which customers it tries to serve. Various sets of customers can be segmented based on their different needs and attributes to ensure appropriate implementation of corporate strategy.",
    theoreticalFoundation: "One of nine building blocks in Osterwalder's Business Model Canvas. Customer segments can include mass market, niche market, segmented, diversified, and multi-sided platforms, each requiring tailored value propositions and relationship strategies.",
    segmentationApproach: "Segments are defined based on different needs, attributes, and jobs-to-be-done, enabling companies to tailor their value propositions and business model elements to specific customer groups."
});

// =====================================================
// 4. JOB EXECUTOR NODES (Create 1 per customer segment)
// Types: core job executor, product lifecycle support team, buyer
// =====================================================

CREATE (je1:JobExecutor {
    id: "je_001",                                    // Change: Sequential IDs
    name: "[JOB EXECUTOR NAME]",                     // Change: Who performs the job
    executorType: "core job executor",               // Options: core job executor, product lifecycle support team, buyer
    roleTitle: "[ROLE/TITLE]",                       // Change: Person's identity in their organization
    industryDomain: "[INDUSTRY/DOMAIN]",             // Change: Professional context they work in
    environment: "[ENVIRONMENT]",                    // Change: Physical or digital setting
    experienceLevel: "[EXPERIENCE LEVEL]",           // Change: Level of expertise with job/domain
    executionFrequency: "[EXECUTION FREQUENCY]",     // Change: How often they perform relevant jobs
    authorityInfluence: "[AUTHORITY/INFLUENCE]",     // Change: Degree of control over tools/decisions
    dependencyStructure: "[DEPENDENCY STRUCTURE]",   // Change: Solo, teams, supervision structure
    constraintsLimitations: "[CONSTRAINTS]",         // Change: Factors restricting job performance
    toolsSystemsUsed: "[TOOLS/SYSTEMS]",            // Change: Common tools/systems/workarounds
    informationBehavior: "[INFO BEHAVIOR]",         // Change: How they gather/validate information
    demographics: "[DEMOGRAPHICS]",                 // Change: Age/location/education if relevant
    
    // Semantic Enhancement Properties - Ulwick's ODI Research
    semanticDescription: "The individual or role responsible for executing a specific job-to-be-done. In ODI methodology, job executors are the people who actually perform the core functional job, and understanding their context, constraints, and capabilities is crucial for developing solutions that fit their execution environment.",
    theoreticalFoundation: "Based on Anthony Ulwick's Outcome-Driven Innovation framework and Tony Ulwick's Jobs-to-be-Done theory. The job executor concept recognizes that understanding WHO performs the job is as important as understanding the job itself, as their context directly influences solution requirements.",
    odiRelevance: "Critical for ODI process as job executors define the execution context, constraints, and success metrics. Their characteristics directly influence what constitutes an effective solution and how outcomes should be measured."
});

// =====================================================
// 5. JOB TO BE DONE NODES (Create 1 per customer segment)
// =====================================================

CREATE (job1:JobToBeDone {
    id: "job_001",                                   // Change: Sequential IDs
    jobStatement: "[VERB + OBJECT + CONTEXT]",       // Change: Clear job statement format
    jobType: "Functional",                           // Options: Functional, Emotional, Social, Related
    contextOfExecution: "[CONTEXT OF EXECUTION]",    // Change: When/where job is performed
    jobCategory: "[JOB CATEGORY]",                   // Change: Thematic grouping (e.g. "Mobility")
    frequency: "[FREQUENCY]",                        // Change: Daily, Weekly, Monthly, Seasonally, etc.
    priorityLevel: "[PRIORITY LEVEL]",               // Change: Perceived importance to executor
    
    // Semantic Enhancement Properties - Christensen & Ulwick Research
    semanticDescription: "A job-to-be-done is a fundamental unit of analysis that describes what customers are trying to accomplish in a given situation. As Clayton Christensen states: 'Customers don't buy products; they pull them into their life to make progress.' A job describes the progress that a customer is trying to make in a particular circumstance.",
    theoreticalFoundation: "Originally conceptualized by Tony Ulwick in 1990 and later popularized by Clayton Christensen. Based on the premise that people buy products and services to get jobs done. The theory provides a framework for categorizing, defining, capturing, and organizing customer needs tied to the job-to-be-done.",
    odiFramework: "In Ulwick's ODI framework, jobs include: (i) core functional job-to-be-done, (ii) desired outcomes tied to the core functional job, (iii) related jobs, (iv) emotional and social jobs, (v) consumption chain jobs, and (vi) buyer's financial desired outcomes.",
    stabilityCharacteristic: "A properly defined functional job-to-be-done is stable over time - it doesn't change. What changes is the solution or technology used to get the job done. This stability makes jobs a reliable foundation for innovation strategy."
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
    
    // Semantic Enhancement Properties - Business Model Canvas Research
    semanticDescription: "Communication and distribution pathways through which an organization reaches its customer segments to deliver value propositions. Channels serve several functions including raising awareness, helping customers evaluate value propositions, allowing purchase, delivering value propositions, and providing post-purchase customer support.",
    theoreticalFoundation: "Part of Osterwalder's Business Model Canvas framework. Channels can be direct (sales force, web sales) or indirect (own stores, partner stores, wholesaler). They vary in terms of revenue potential, cost, and level of integration with business model.",
    channelFunctions: "Channels serve multiple functions: awareness (how do we raise awareness about our products and services?), evaluation (how do we help customers evaluate our value proposition?), purchase (how do customers purchase our products?), delivery (how do we deliver our value proposition?), after sales (how do we provide post-purchase customer support?)."
});

// DELIVERY CHANNEL (How to deliver value)
CREATE (ch2:Channel {
    id: "ch_002",
    name: "[DELIVERY CHANNEL NAME]",                 // Change: e.g., "Mobile App"
    channelType: "delivery",                         // Keep: delivery
    medium: "digital",                               // Options: digital, physical, hybrid
    ownership: "owned",                              // Options: owned, partner, hybrid
    semanticDescription: "Communication and distribution pathways through which an organization reaches its customer segments to deliver value propositions.",
    theoreticalFoundation: "Part of Osterwalder's Business Model Canvas framework. Channels can be direct or indirect and vary in terms of revenue potential, cost, and integration.",
    channelFunctions: "Primary function is value delivery to customers through appropriate medium and ownership structure."
});

// RETENTION CHANNEL (How to retain customers)
CREATE (ch3:Channel {
    id: "ch_003",
    name: "[RETENTION CHANNEL NAME]",                // Change: e.g., "Customer Success Program"
    channelType: "retention",                        // Keep: retention
    medium: "hybrid",                                // Options: digital, physical, hybrid
    ownership: "owned",                              // Options: owned, partner, hybrid
    semanticDescription: "Communication and distribution pathways through which an organization reaches its customer segments to deliver value propositions.",
    theoreticalFoundation: "Part of Osterwalder's Business Model Canvas framework focused on customer retention and relationship maintenance.",
    channelFunctions: "Primary function is customer retention through ongoing engagement and post-purchase support."
});

// =====================================================
// 7. CUSTOMER RELATIONSHIP NODES (Create 2-4)
// =====================================================

CREATE (cr1:CustomerRelationship {
    id: "cr_001",                                    // Change: Sequential IDs
    type: "personal",                                // Options: personal, automated, self-service, community
    purpose: "acquisition",                          // Options: acquisition, retention, boosting sales
    description: "[RELATIONSHIP DESCRIPTION]",       // Change: How you interact with customers
    
    // Semantic Enhancement Properties - Osterwalder Research
    semanticDescription: "The types of relationships a company establishes with specific customer segments. Customer relationships can range from personal to automated, and are driven by customer acquisition, customer retention, and boosting sales motivations. Each customer segment has specific relationship expectations.",
    theoreticalFoundation: "Component of Osterwalder's Business Model Canvas focusing on relationship management strategy. Different customer segments expect different types of relationships, from high-touch personal assistance to efficient self-service platforms.",
    relationshipTypes: "Categories include: Personal assistance (human interaction during sales and after), Dedicated personal assistance (dedicated customer representatives), Self-service (companies maintain no direct relationship), Automated services (automated processes), Communities (user communities facilitate connections), Co-creation (companies engage customers in value creation)."
});

CREATE (cr2:CustomerRelationship {
    id: "cr_002",
    type: "automated",                               // Options: personal, automated, self-service, community
    purpose: "retention",                            // Options: acquisition, retention, boosting sales
    description: "[AUTOMATED RELATIONSHIP DESC]",    // Change: Automated interaction description
    semanticDescription: "The types of relationships a company establishes with specific customer segments through automated processes and systems.",
    theoreticalFoundation: "Component of Osterwalder's Business Model Canvas focusing on scalable relationship management through automation.",
    relationshipTypes: "Automated services that provide customer value without direct human interaction, including recommendation systems, self-service platforms, and automated customer support."
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
    frequency: "monthly",                           // Change: monthly, annual, per-transaction
    
    // Semantic Enhancement Properties - Business Model Canvas Research
    semanticDescription: "The cash a company generates from each customer segment. Revenue streams represent the arteries of a business model and answer the question: For what value is each customer segment truly willing to pay? Revenue can be generated through various mechanisms including asset sales, usage fees, subscription fees, lending/renting/leasing, licensing, brokerage fees, and advertising.",
    theoreticalFoundation: "Core component of Osterwalder's Business Model Canvas representing the financial viability element. Revenue streams can have different pricing mechanisms including fixed list prices, bargaining, auctioning, market dependent, volume dependent, or yield management.",
    revenueTypes: "Revenue generation methods: Asset sale (selling ownership rights), Usage fee (pay-per-use), Subscription fees (selling continuous access), Lending/Renting/Leasing (temporarily granting exclusive rights), Licensing (granting permission to use protected intellectual property), Brokerage fees (intermediation services), Advertising (advertising space fees)."
});

CREATE (rs2:RevenueStream {
    id: "rs_002",
    name: "[SECOND REVENUE STREAM]",                 // Change: e.g., "Enterprise Licenses"
    type: "recurring",                               // Options: one-time, recurring
    pricingMechanism: "dynamic",                     // Options: fixed, dynamic, market-based
    amount: 10000.0,                                // Change: Revenue amount per period
    frequency: "annual",                            // Change: monthly, annual, per-transaction
    semanticDescription: "The cash a company generates from each customer segment through value delivery mechanisms.",
    theoreticalFoundation: "Core component of Osterwalder's Business Model Canvas representing financial sustainability through customer value monetization.",
    revenueTypes: "Focused on enterprise-level revenue generation through licensing, subscriptions, or value-based pricing models."
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
    
    // Semantic Enhancement Properties - Business Model Canvas Research
    semanticDescription: "The most important assets required to make a business model work. Key resources allow an enterprise to create and offer a value proposition, reach markets, maintain relationships with customer segments, and earn revenues. Different business models require different key resources, which can be owned, leased, or acquired from partners.",
    theoreticalFoundation: "Essential building block of Osterwalder's Business Model Canvas representing the asset foundation. Resources can be physical (manufacturing facilities, buildings, vehicles, machines, systems), intellectual (brands, proprietary knowledge, patents, copyrights, partnerships, customer databases), human (talented individuals, particularly in knowledge-intensive and creative industries), or financial (cash, lines of credit, stock option pools).",
    resourceCategories: "Physical resources (manufacturing facilities, buildings, vehicles, machines, systems, point-of-sales systems, distribution networks), Intellectual resources (brands, proprietary knowledge, patents and copyrights, partnerships, customer databases), Human resources (creative industries and knowledge-intensive industries require talented people), Financial resources (cash, lines of credit, stock option pools for hiring key employees)."
});

CREATE (kr2:KeyResource {
    id: "kr_002",
    name: "[HUMAN RESOURCE NAME]",                   // Change: e.g., "Development Team"
    type: "human",                                   // Options: physical, intellectual, human, financial
    description: "[TEAM DESCRIPTION]",               // Change: Who they are and what they do
    ownership: "owned",                              // Options: owned, leased, partner
    semanticDescription: "The most important human assets required to make a business model work, particularly in knowledge-intensive and creative industries.",
    theoreticalFoundation: "Human resources component of Osterwalder's Business Model Canvas, recognizing that talented individuals are essential for certain business models.",
    resourceCategories: "Human resources including skilled personnel, creative talent, domain experts, and knowledge workers essential for value creation and delivery."
});

CREATE (kr3:KeyResource {
    id: "kr_003",
    name: "[INFRASTRUCTURE NAME]",                   // Change: e.g., "Cloud Infrastructure"
    type: "physical",                                // Options: physical, intellectual, human, financial
    description: "[INFRASTRUCTURE DESCRIPTION]",     // Change: Technical infrastructure
    ownership: "leased",                             // Options: owned, leased, partner
    semanticDescription: "The most important physical assets and infrastructure required to make a business model work.",
    theoreticalFoundation: "Physical resources component of Osterwalder's Business Model Canvas including facilities, systems, and distribution networks.",
    resourceCategories: "Physical infrastructure including technology systems, facilities, equipment, and distribution networks that enable business operations."
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
    
    // Semantic Enhancement Properties - Business Model Canvas Research
    semanticDescription: "The most important things a company must do to make its business model work. Key activities are the critical actions a company must take to operate successfully. These activities are required to create and offer a value proposition, reach markets, maintain customer relationships, and earn revenues.",
    theoreticalFoundation: "Core building block of Osterwalder's Business Model Canvas representing operational requirements. Activities vary based on business model type and can be categorized as production activities (designing, making, and delivering products), problem-solving activities (developing new solutions to individual customer problems), or platform/network activities (managing platforms, networks, and matchmaking software).",
    activityCategories: "Production activities (designing, making, and delivering a product in substantial quantities and/or of superior quality - dominant in manufacturing firms), Problem solving (new knowledge-intensive activities such as consulting, hospitals, training - developing solutions to individual customer problems), Platform/Network activities (software platforms, networks, brands as platforms - managing platforms as key activities)."
});

CREATE (ka2:KeyActivity {
    id: "ka_002",
    name: "[MARKETING ACTIVITY]",                    // Change: e.g., "Customer Acquisition"
    type: "problem-solving",                         // Options: production, problem-solving, platform/network
    description: "[MARKETING DESCRIPTION]",          // Change: Marketing and sales activities
    priority: "high",                                // Options: high, medium, low
    semanticDescription: "Critical problem-solving activities focused on customer acquisition and market development.",
    theoreticalFoundation: "Problem-solving category of Osterwalder's Business Model Canvas, focusing on developing solutions for customer acquisition and retention challenges.",
    activityCategories: "Problem-solving activities including market research, customer acquisition, sales processes, and relationship management."
});

CREATE (ka3:KeyActivity {
    id: "ka_003",
    name: "[SUPPORT ACTIVITY]",                      // Change: e.g., "Customer Support"
    type: "problem-solving",                         // Options: production, problem-solving, platform/network
    description: "[SUPPORT DESCRIPTION]",            // Change: Customer support activities
    priority: "medium",                              // Options: high, medium, low
    semanticDescription: "Problem-solving activities focused on customer support and service delivery.",
    theoreticalFoundation: "Problem-solving category emphasizing individual customer problem resolution and support services.",
    activityCategories: "Customer support, technical assistance, and service delivery activities that maintain customer relationships."
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
    value: 100000.0,                                // Change: Annual value of partnership
    
    // Semantic Enhancement Properties - Business Model Canvas Research
    semanticDescription: "The network of suppliers and partners that make the business model work. Companies create alliances to optimize their business models, reduce risk, or acquire resources. Partnerships are becoming a cornerstone of many business models as companies seek to focus on their core activities while leveraging partners for non-core capabilities.",
    theoreticalFoundation: "Strategic building block of Osterwalder's Business Model Canvas representing external relationship management. Partnerships can be motivated by optimization and economy of scale (buyer-supplier relationships to optimize allocation of resources), reduction of risk and uncertainty (strategic alliances in uncertain environments), or acquisition of particular resources and activities (access to licenses, knowledge, customers).",
    partnershipTypes: "Strategic alliances between non-competitors (partnerships between companies in different industries or between competitors in specific market segments), Coopetition (strategic partnerships between competitors), Joint ventures (developing new business opportunities), Buyer-supplier relationships (ensuring reliable supplies and optimizing supply chains)."
});

CREATE (kp2:KeyPartnership {
    id: "kp_002",
    partnerName: "[STRATEGIC PARTNER]",              // Change: Strategic alliance partner
    type: "strategic alliance",                      // Options: strategic alliance, joint venture, supplier relationship
    motivation: "[STRATEGIC MOTIVATION]",            // Change: Strategic partnership reason
    description: "[STRATEGIC DESCRIPTION]",          // Change: Strategic partnership details
    value: 250000.0,                                // Change: Annual value of partnership
    semanticDescription: "Strategic alliances that optimize business model capabilities and reduce operational risks.",
    theoreticalFoundation: "Strategic alliance component of Osterwalder's Business Model Canvas focused on collaborative advantage and risk mitigation.",
    partnershipTypes: "Strategic alliances focused on market expansion, technology access, or competitive positioning through collaborative relationships."
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
    frequency: "monthly",                           // Change: monthly, annual, quarterly
    
    // Semantic Enhancement Properties - Business Model Canvas Research
    semanticDescription: "All costs incurred to operate a business model. Cost structure describes the most important costs incurred while operating under a particular business model. Creating and delivering value, maintaining customer relationships, and generating revenue all incur costs. Business models can be cost-driven (focused on minimizing costs) or value-driven (focused on value creation).",
    theoreticalFoundation: "Financial foundation element of Osterwalder's Business Model Canvas representing expense management. Costs can be calculated relatively easily after defining key resources, key activities, and key partnerships. Some business models are more cost-driven than others, with cost structures having fixed costs, variable costs, economies of scale, and economies of scope characteristics.",
    costTypes: "Fixed costs (costs that remain the same despite volume of goods or services produced - salaries, rents, facilities), Variable costs (costs that vary proportionally with volume of goods or services produced), Economies of scale (cost advantages obtained with increased output), Economies of scope (cost advantages from larger scope of operations - same marketing activities for multiple products)."
});

CREATE (cost2:CostStructure {
    id: "cost_002",
    name: "[INFRASTRUCTURE COSTS]",                  // Change: e.g., "Technology Infrastructure"
    type: "variable",                                // Options: fixed, variable
    category: "infrastructure",                      // Options: operational, marketing, infrastructure
    amount: 50000.0,                                // Change: Monthly cost amount
    frequency: "monthly",                           // Change: monthly, annual, quarterly
    semanticDescription: "Infrastructure costs that vary with business model scale and technology requirements.",
    theoreticalFoundation: "Variable cost component of Osterwalder's Business Model Canvas focused on technology and infrastructure expenses.",
    costTypes: "Variable infrastructure costs including technology systems, cloud services, and scalable platform expenses."
});

CREATE (cost3:CostStructure {
    id: "cost_003",
    name: "[MARKETING COSTS]",                       // Change: e.g., "Sales & Marketing"
    type: "variable",                                // Options: fixed, variable
    category: "marketing",                           // Options: operational, marketing, infrastructure
    amount: 100000.0,                               // Change: Monthly cost amount
    frequency: "monthly",                           // Change: monthly, annual, quarterly
    semanticDescription: "Marketing and sales costs that vary with customer acquisition and retention activities.",
    theoreticalFoundation: "Variable cost component focused on customer-facing activities and market development expenses.",
    costTypes: "Variable marketing costs including advertising, customer acquisition, sales activities, and market development initiatives."
});

// =====================================================
// USAGE INSTRUCTIONS WITH SEMANTIC ENHANCEMENT:
// =====================================================

// 1. Copy each template section above
// 2. Replace all [PLACEHOLDER TEXT] with your specific values
// 3. Update IDs to be sequential (vp_001, vp_002, etc.)
// 4. Adjust costs, amounts, and ratings to match your business
// 5. Customize semantic descriptions to reflect your specific context
// 6. Keep theoretical foundations as research-based references
// 7. Run all CREATE statements in Neo4j after customization

// =====================================================
// SEMANTIC ENHANCEMENT BENEFITS:
// =====================================================

// - Each node contains authoritative business theory definitions
// - Theoretical foundations provide academic credibility
// - Semantic descriptions enable rich queries and analysis
// - Research citations establish knowledge provenance
// - Educational value for team members and stakeholders
// - Consistent terminology across business model components

// =====================================================
// NEXT STEPS:
// =====================================================

// After creating all nodes with semantic enhancement:
// 1. Use Relationship-Templates.cypher to connect nodes
// 2. Query semantic descriptions for business insights
// 3. Leverage theoretical foundations for strategic analysis
// 4. Use research-based definitions for stakeholder education
// 5. Build upon established business model frameworks

// =====================================================