{{- define "elasticsearchClusterNodes" -}}
{{- $releaseName := .Name | toString }}
{{- $nodeCount := .Replicas | int }}
  {{- range $outerIndex := until $nodeCount -}}
   {{- $innerIndex := $outerIndex | add1 -}}
{{ $releaseName }}-elasticsearch-{{ $outerIndex }}.{{ $releaseName }}-elasticsearch:14230{{ if ne $innerIndex $nodeCount }},{{ end }}
  {{- end -}} 
{{- end -}}


{{- define "aris.customLabelsGlobal" -}}
{{- $allLabels :=  dict -}}
{{- if .root.Values.customLabels.global -}}
{{- $allLabels := merge $allLabels .root.Values.customLabels.global -}}
{{- end }}
{{- include "aris.renderLabels" $allLabels -}}
{{- end -}}

{{- define "aris.renderLabels" -}}
{{- range $key,$value := $ }}{{ $key }}: {{ $value | quote }}
{{ end }}
{{- end -}}
