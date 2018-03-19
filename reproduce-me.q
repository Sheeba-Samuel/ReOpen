[QueryGroup="Experiment Dashboard Queries"] @collection [[
[QueryItem="The Plot"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
Select DISTINCT ?Experiment ?AgentName ?AgentRole ?startedAtTime ?generatedAtTime WHERE { 
	?exp  a :Experiment ; 
		:name ?Experiment ; :status ?status ;
        	:datasetid ?datasetid ; prov:wasAttributedTo ?Agent . 
  	{ ?Agent a :Project } UNION { ?Agent a :ResearchGroup } . 
        ?Agent :name ?AgentName ; rdfs:label ?AgentRole . 
 	OPTIONAL { ?exp prov:startedAtTime ?startedAtTime ; prov:generatedAtTime ?generatedAtTime } 
}

[QueryItem="The Characters"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
SELECT  ?Experiment ?PersonName ?PersonRole ?Plan WHERE  { 
	?exp prov:wasAttributedTo ?person . 
        ?person a prov:Agent ; rdfs:label ?PersonRole . 
        OPTIONAL { ?person :name ?PersonName } .   
        ?exp p-plan:isOutputVarOf ?step . 
        ?step p-plan:isStepOfPlan ?plan . 
        ?plan rdfs:label ?Plan . 
        ?plan p-plan:isSubPlanOfPlan ?MainPlan . 
	?MainPlan :name ?Experiment ; :status ?status ; :datasetid ?datasetid .
}


[QueryItem="Experiment Materials"]
Select DISTINCT ?Experiment ?Name ?UniqueName ?MaterialReferencesName ?ReferencesMaterialName ?StoredAt  WHERE { 
    	?exp  a :Experiment ; :name ?Experiment ; :status ?status ; :datasetid ?datasetid  . 
    	?material a :ExperimentMaterial . 
    	?exp p-plan:correspondsToVariable ?material . 
    	?material :name ?Name . 
	OPTIONAL { ?material :reference ?MaterialReferences } . 
	OPTIONAL { ?MaterialReferences :status ?status FILTER(?status=1) } . 
        OPTIONAL { ?MaterialReferences :name ?MaterialReferencesName } . 
	OPTIONAL { ?ReferencesMaterial :reference ?material } . 
	OPTIONAL { ?ReferencesMaterial :status ?status FILTER(?status=1) } . 
        OPTIONAL { ?ReferencesMaterial :name ?ReferencesMaterialName } . 
	OPTIONAL { ?material :uniqueid ?UniqueName } . 
	OPTIONAL { ?material :storedAt ?storedAt } . 
	OPTIONAL { ?storedAt :description ?StoredAt } . 
}


[QueryItem="External Resources"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
Select DISTINCT ?Experiment ?Step ?Plan ?ReferencePaper ?ReferencePaperDOI ?ReferencePaperPUBMedId WHERE {  
	?paper a :Publication ; p-plan:isInputVarOf ?step .                 
	OPTIONAL { ?paper :referencepaper ?ReferencePaper ; :referencepaperdoi ?ReferencePaperDOI ; :referencepaperpubmedid ?ReferencePaperPUBMedId } . 
	?step rdfs:label ?Step ; p-plan:isStepOfPlan ?plan . 
	?plan rdfs:label ?Plan ; p-plan:isSubPlanOfPlan ?MainPlan . 
	?MainPlan :name ?Experiment ; :datasetid ?datasetid . 
}


[QueryItem="Files Used"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
Select DISTINCT * WHERE { 
    	?exp  a :Experiment ; :name ?Experiment ; :status ?status FILTER(?status=1) . 
    	?exp :datasetid ?datasetid . 
    	?exp p-plan:correspondsToVariable ?material . 
    	?material :name ?MaterialName . 
	?MaterialReferences a :File . 
	{ ?material :reference ?MaterialReferences } UNION { ?material a :File } . 
	?MaterialReferences :name ?FileName ; p-plan:isInputVarOf ?step ;
	:status ?status FILTER(?status=1) .   				
	OPTIONAL { ?step rdfs:label ?Step } 
}

[QueryItem="Jupyter Notebooks"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
Select DISTINCT * WHERE { 
        ?notebook a :Notebook ;  :name ?NotebookName ; prov:generatedAtTime ?generatedAtTime ; :modifiedAtTime ?modifiedAtTime . 
        ?NotebookStep p-plan:isStepOfPlan ?notebook ; p-plan:hasOutputVar ?output ;  :type ?StepType . 
        ?output prov:value ?OutputValue ; :type ?OutputType ;  :name ?OutputName 
}

[QueryItem="Instruments:Detector"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
SELECT DISTINCT ?Image ?instrument_part ?InstrumentType ?SettingName ?SettingValue WHERE { 
        ?image a :Image ; :name ?Image .
        ?dataset a :Dataset ;  :id ?datasetid  ; prov:hadMember ?image .
        ?instrument p-plan:correspondsToVariable ?image .
        ?instrument_part a :Detector ; :isPartOf ?instrument .
	?instrument_part :hasSetting ?setting .
	?setting a :Setting . 
        ?setting rdfs:label ?SettingName .
	OPTIONAL { ?setting prov:value ?SettingValue } .
        OPTIONAL { ?instrument_type prov:specializationOf ?instrument_part ; 
        prov:value ?InstrumentType } . 	
}


[QueryItem="Instrument Settings:Detector"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
SELECT DISTINCT ?Image ?instrument_part ?InstrumentType ?SettingName ?SettingValue WHERE { 
        ?image a :Image ; :name ?Image .
        ?dataset a :Dataset ;  :id ?datasetid  ; prov:hadMember ?image .
        ?instrument p-plan:correspondsToVariable ?image .
        ?instrument_part a :Detector ; :isPartOf ?instrument .
	?instrument_part :hasSetting ?setting .
	?setting a :Setting . 
        ?setting :hasSetting ?VariableSetting .
        ?VariableSetting rdfs:label ?SettingName .
	OPTIONAL { ?VariableSetting prov:value ?SettingValue }
        OPTIONAL { ?instrument_type prov:specializationOf ?instrument_part ; 
        prov:value ?InstrumentType } . 	
}

[QueryItem="Instruments:Objective"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
SELECT DISTINCT ?Image ?instrument_part ?InstrumentType ?SettingName ?SettingValue WHERE { 
        ?image a :Image ; :name ?Image .
        ?dataset a :Dataset ;  :id ?datasetid  ; prov:hadMember ?image .
        ?instrument p-plan:correspondsToVariable ?image .
        ?instrument_part a :Objective ; :isPartOf ?instrument .
	?instrument_part :hasSetting ?setting .
	?setting a :Setting . 
        ?setting rdfs:label ?SettingName .
	OPTIONAL { ?setting prov:value ?SettingValue } .
        OPTIONAL { ?instrument_type prov:specializationOf ?instrument_part ; 
        prov:value ?InstrumentType } . 	
}


[QueryItem="Instruments:Objective Settings"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
SELECT DISTINCT ?Image ?instrument_part ?InstrumentType ?SettingName ?SettingValue WHERE { 
        ?image a :Image ; :name ?Image .
        ?dataset a :Dataset ;  :id ?datasetid  ; prov:hadMember ?image .
        ?instrument p-plan:correspondsToVariable ?image .
        ?instrument_part a :Objective ; :isPartOf ?instrument .
	?instrument_part :hasSetting ?setting .
	?setting a :Setting . 
        ?setting :hasSetting ?VariableSetting .
        ?VariableSetting rdfs:label ?SettingName .
	OPTIONAL { ?VariableSetting prov:value ?SettingValue }
        OPTIONAL { ?instrument_type prov:specializationOf ?instrument_part ; 
        prov:value ?InstrumentType } . 	
}

[QueryItem="Instruments:Dichroic"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
SELECT DISTINCT ?Image ?instrument_part ?InstrumentType ?SettingName ?SettingValue WHERE { 
        ?image a :Image ; :name ?Image .
        ?dataset a :Dataset ;  :id ?datasetid  ; prov:hadMember ?image .
        ?instrument p-plan:correspondsToVariable ?image .
        ?instrument_part a :Dichroic ; :isPartOf ?instrument .
	?instrument_part :hasSetting ?setting .
	?setting a :Setting . 
        ?setting rdfs:label ?SettingName .
	OPTIONAL { ?setting prov:value ?SettingValue } .
        OPTIONAL { ?instrument_type prov:specializationOf ?instrument_part ; 
        prov:value ?InstrumentType } . 	
}

[QueryItem="Instruments:Filter"]
PREFIX : <http://fusion.cs.uni-jena.de/fusion/repr/#> 
PREFIX p-plan: <http://purl.org/net/p-plan#>
PREFIX prov: <http://www.w3.org/ns/prov#>
SELECT DISTINCT ?Image ?instrument_part ?InstrumentType ?SettingName ?SettingValue WHERE { 
        ?image a :Image ; :name ?Image .
        ?dataset a :Dataset ;  :id ?datasetid  ; prov:hadMember ?image .
        ?instrument p-plan:correspondsToVariable ?image .
        ?instrument_part a :Filter ; :isPartOf ?instrument .
	?instrument_part :hasSetting ?setting .
	?setting a :Setting . 
        ?setting rdfs:label ?SettingName .
	OPTIONAL { ?setting prov:value ?SettingValue } .
        OPTIONAL { ?instrument_type prov:specializationOf ?instrument_part ; 
        prov:value ?InstrumentType } . 	
}
]]


