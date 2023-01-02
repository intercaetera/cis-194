const fs = require('fs')

const unprocessLine = line => `${line.type} ${line.severity} ${line.timestamp} ${line.message}`

const isRelevant = line => line.type === 'E' && line.severity >= 50

const sortMessages = (a, b) => a.timestamp - b.timestamp

const processErrorLine = line => {
	const type = 'E'
	const severity = Number(line[1])
	const timestamp = Number(line[2])
	const message = line.slice(3).join(' ')

	return { type, severity, timestamp, message }
}

const processSimpleLine = line => {
	const type = line[0]
	const timestamp = Number(line[1])
	const message = line.slice(2).join(' ')

	return { type, severity: null, timestamp, message }
}

const processLine = l => {
	const line = l.split(' ')

	const type = line[0]
	const processedLine = type === 'E' ? processErrorLine(line) : processSimpleLine(line)

	return processedLine
}

const removeInvalidLines = l => {
	const line = l.split(' ')
	const type = line[0]

	return type === 'E' || type === 'W' || type === 'I'
}

const fileContent =
	fs.readFileSync('./error.log', 'utf-8')
	.split('\n')
	.filter(removeInvalidLines)
	.map(processLine)
	.sort(sortMessages)
	.filter(isRelevant)
	.map(unprocessLine)
	.join('\n')

console.log(fileContent)
