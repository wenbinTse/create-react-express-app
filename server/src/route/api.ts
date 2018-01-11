import { Router, Request, Response, NextFunction } from 'express';

const router = Router();

router.get('/hello', (req: Request, res: Response) => {
  res.send('hello');
});

export = router;
