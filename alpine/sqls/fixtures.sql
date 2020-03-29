INSERT INTO public.contacts
    (
        email,
        firstname,
        lastname
    )
    SELECT
        'firstname' || to_char(seqnum, 'FM0000') || '@example.com',
        'firstname' || to_char(seqnum, 'FM0000'),
        'lastname' || to_char(seqnum, 'FM0000')
    FROM 
        GENERATE_SERIES(1, 10) seqnum;