# Evaluation 1

## Données

Dans cette évaluation, nous allons travailler sur des données concernant des logements AirBnB. Celles-ci sont stockées sur le serveur Mongo dans la **collection `listingsAndReviews`** de la **base `sample_airbnb`**. Vous trouverez ci-dessous le contenu du premier document (réduit aux éléments importants pour cette évaluation - les textes longs ont été remplacé par `"..."`).

```json
{  
    "_id": "10082422",  
    "listing_url": "https://www.airbnb.com/rooms/10082422",  
    "name": "Nice room in Barcelona Center",  
    "summary": "...",  
    "description": "...",  
    "neighborhood_overview": "Dreta de l'Eixample",  
    "property_type": "Apartment",  
    "room_type": "Private room",  
    "bed_type": "Real Bed",  
    "minimum_nights": "1",  
    "maximum_nights": "9",  
    "cancellation_policy": "flexible",  
    "accommodates": 2,  
    "bedrooms": 1,  
    "beds": 2,  
    "bathrooms": { "$numberDecimal": "1.0" },  
    "amenities": [ "Internet", "Wifi", "..." ],  
    "price": { "$numberDecimal": "50.00" },  
    "security_deposit": { "$numberDecimal": "100.00" },  
    "cleaning_fee": { "$numberDecimal": "10.00" },  
    "extra_people": { "$numberDecimal": "0.00" },  
    "guests_included": { "$numberDecimal": "1" },  
    "host": {    
        "host_id": "30393403",    
        "host_name": "Anna",    
        "host_location": "Barcelona, Catalonia, Spain",    
        "host_neighbourhood": "Dreta de l'Eixample",    
    },  
    "address": {    
        "street": "Barcelona, Catalunya, Spain",    
        "suburb": "Eixample",   
        "government_area": "la Dreta de l'Eixample",    
        "market": "Barcelona",    
        "country": "Spain",    
        "country_code": "ES",    
        "location": {      
            "type": "Point",      
            "coordinates": [        2.16942,        41.40082      ],      
            "is_location_exact": true    
        }
    },  
    "availability": {    "availability_30": 0,    "availability_60": 0,    "availability_90": 0,    "availability_365": 0  },  
    "review_scores": {},  
    "reviews": []
}
```

> [Aide sur les données](https://docs.atlas.mongodb.com/sample-data/sample-airbnb)

## Questions

Vous devez vous connecter au serveur distant (cf précédents TPs). Ensuite, vous pouvez répondre aux questions dans le formulaire ci-dessous.

> **ATTENTION A BIEN METTRE LE CODE MONGO ET PAS LE RESULTAT !!!**


<iframe src="https://docs.google.com/forms/d/e/1FAIpQLSfmtu6TcwmuNM465zCWxUWoDw4lHVyt_UJHlNQrZeETMTUFwQ/viewform?embedded=true" width="640" height="2512" frameborder="0" marginheight="0" marginwidth="0">Chargement…</iframe>
