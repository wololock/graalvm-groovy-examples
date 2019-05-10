import groovy.json.JsonOutput
import groovy.json.JsonSlurper

def filename = args[0]
def classes = args[1].tokenize(",")
def file = new File(filename)

def root = new JsonSlurper().parse(file)

def filtered = root.findAll { !(it.name in classes) }

file.newWriter().withWriter {
    it << JsonOutput.prettyPrint(JsonOutput.toJson(filtered)).replaceAll("    ", "  ")
}