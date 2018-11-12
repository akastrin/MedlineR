## http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=STE12+AND+SST2

require(xml2)
options("serviceUrl.entrez" = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/")

## Count the number of abstracts with both term1 and term2
countApair <- function(term1, term2, termAdditional = "", baseUrl = getOption("serviceUrl.entrez")) {
    if (is.null(baseUrl)) {
        stop("Need to define the URL of the PubMed service!")
    }

    query <- paste(baseUrl, "esearch.fcgi?", "db=pubmed&", "rettype=counts&", "term=", term1,
                   "+AND+", term2, termAdditional, sep = "")
    doc <- read_xml(query)
    count <- doc %>% xml_find_all("./Count") %>% xml_integer()
    return(count)
}

pauseBetweenQueries <- function(sleep.peak = 15, sleep.offpeak = 3) {
    result.date <- unlist(strsplit(date(), split = " "))
    hour <- as.numeric(unlist(strsplit(result.date[4], split = ":"))[1])
    if ((result.date[1]  == "Sat") | (result.date[1] == "Sun") | (hour > 21) | (hour < 5)) {
        off.peak <- TRUE
    } else {
        off.peak <- FALSE
    }
    if (off.peak) {
        Sys.sleep(sleep.offpeak)
    } else {
        Sys.sleep(sleep.peak)
    }
}

getAmatrix <- function(termList, termAdditional = "") {
    n.terms <- length(termList)
    result.matrix <- matrix(0, ncol = n.terms, nrow = n.terms)
    for (i in 1:n.terms) {
        result.matrix[i, i] <- countApair(term1 = termList[i], term2 = termList[i],
                                          termAdditional = termAdditional)
        pauseBetweenQueries()
    }
    ## Query the pairs
    for (i in 1:(n.terms - 1)) {
        if (result.matrix[i, i] == 0) {
            next
        }
        for (j in (i + 1):n.terms) {
            n.counts <- countApair(term1 = termList[i], term2 = termList[j],
                                   termAdditional = termAdditional)
            pauseBetweenQueries()
            result.matrix[i, j] <- n.counts
            result.matrix[j, i] <- n.counts
        }
    }
    return(result.matrix)
}
